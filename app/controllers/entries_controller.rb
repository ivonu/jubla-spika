class EntriesController < ApplicationController

  before_action :authorize_user, except: [:index, :show, :plan]
  before_action :authorize_moderator, only: [:not_published, :publish, :keep, :destroy_final]

  def index

    @plan_start = (session[:plan_start] == nil) ? [] : session[:plan_start]
    @plan_main = (session[:plan_main] == nil) ? [] : session[:plan_main]
    @plan_end = (session[:plan_end] == nil) ? [] : session[:plan_end]
    @plan = (@plan_start.size() != 0) || (@plan_main.size() != 0) || (@plan_end.size() != 0)

    @hide_programs = false
    @only_programs = false
    @shown_programs = []
    if params[:filterrific] != nil
      if params[:filterrific]["with_part_start"] == "1" then @hide_programs = true end
      if params[:filterrific]["with_part_main"] == "1" then @hide_programs = true end
      if params[:filterrific]["with_part_end"] == "1" then @hide_programs = true end
      if params[:filterrific]["only_programs"] == "1" then @only_programs = true end
    elsif session[:shared_key] != nil
      if session[:shared_key]["with_part_start"] == 1 then @hide_programs = true end
      if session[:shared_key]["with_part_main"] == 1 then @hide_programs = true end
      if session[:shared_key]["with_part_end"] == 1 then @hide_programs = true end
      if session[:shared_key]["only_programs"] == 1 then @only_programs = true end
    end

    if @only_programs
      @filterrific = initialize_filterrific(
        Program,
        params[:filterrific],
        select_options: {
          sorted_by: Entry.options_for_sorted_by,
          num_group: Entry.options_for_num_group,
          num_age: Entry.options_for_num_age,
          num_time: Entry.options_for_num_time
        },
        persistence_id: 'shared_key'
      ) or return 
      @entries = @filterrific.find.where(done: true, published: true).paginate(:page => params[:page], :per_page => 20)
    else
      @filterrific = initialize_filterrific(
        Entry,
        params[:filterrific],
        select_options: {
          sorted_by: Entry.options_for_sorted_by,
          num_group: Entry.options_for_num_group,
          num_age: Entry.options_for_num_age,
          num_time: Entry.options_for_num_time
        },
        persistence_id: 'shared_key'
      ) or return
      @entries = @filterrific.find.where(independent: true, published: true).paginate(:page => params[:page], :per_page => 20)
    end

    respond_to do |format|
      format.html
      format.js
    end

    rescue ActiveRecord::RecordNotFound => e
      puts "Ein Fehler ist aufgetreten und der Filter wurde zurueckgesetzt: #{ e.message }"
      redirect_to(reset_filterrific_url(format: :html)) and return

  end

  def show
    @entry = Entry.find(params[:id])

    if session[:add_ex_entry]
      program = Program.find(session[:add_ex_entry])
      order = session[:add_ex_entry_order]
      session.delete(:add_ex_entry)
      session.delete(:add_ex_entry_order)

      last_program_entry = ProgramEntry.where(program: program).where(order: (order..(order+99))).order(:order).last
      order = last_program_entry.order+1 if last_program_entry
      @program_entry = ProgramEntry.create(program: program, order: order, entry: @entry)
      program = update_program_attributes(program)
      program.save
      redirect_to @program_entry.program
    else
      if not @entry.published
        flash[:alert] = "Dieser Eintrag muss noch von einem Moderator veroeffentlicht werden, bevor er in der Suche erscheint."
      end

      if not @entry.delete_comment == nil and @entry.programs.count > 0
        flash[:error] = "Achtung: Dieser Eintrag kommt in Gruppenstunden vor. Falls er geloescht wird, fehlen diesen Gruppenstunden eventuell wichtige Teile!"
      end

      respond_to do |format|
        format.html
        format.pdf do
          render  :pdf => "Spika_Eintrag",
                  :template => 'entries/show.pdf.erb',
                  :page_size => 'A4',
                  :footer => {:left => "spika.jubla.ch", :center => "Spielkatapult", :right => 'Seite [page] von [topage]' }
        end
      end
    end
  end

  def new
    @entry = Entry.new()
  end

  def create
    @entry = Entry.new(entry_params)
    @entry.user = current_user
    @entry.published = false
    @program_entry = ProgramEntry.new(program_entry_params) if params[:program_entry].present?

    if @entry.save

      if @program_entry
        @program_entry.entry = @entry
        if @program_entry.save
          program = @program_entry.program
          program = update_program_attributes(program)
          program.save
          if program.published
            flash[:alert] = "Dieser Eintrag muss noch von einem Moderator veroeffentlicht werden, bevor er in der Gruppenstunde erscheint."
          end
          redirect_to @program_entry.program
        end
      else
        redirect_to @entry
      end
    else
      render 'new'
    end
  end


  def edit
    @entry = Entry.find(params[:id])
    if Entry.where(edited_entry: @entry).count != 0
      flash[:error] = "Dieser Eintrag wurde bereits bearbeitet, aber noch nicht freigeschaltet und kann daher zurzeit nicht bearbeitet werden."
      redirect_to @entry
    end
  end

  def update
    @entry = Entry.find(params[:id])
    if not @entry.published
      if not current_user.is_moderator?
        authorize_entry_owner @entry
      end
      @entry.update(entry_params)
      redirect_to @entry
    else
      @entry = Entry.new(entry_params)
      @entry.user = current_user
      @entry.published = false
      @entry.edited_entry = Entry.find(params[:id])
     
      if @entry.save
        redirect_to @entry
      else
        render 'edit'
      end
    end
  end


  def destroy
    @entry = Entry.find(params[:id])
    if not @entry.published
      if not current_user.is_moderator?
        authorize_entry_owner @entry
      end
      destroy_entry
      redirect_to entries_path
    else
      if @entry.delete_comment != nil
        flash[:error] = "Dieser Eintrag wurde bereits zum entfernen markiert, aber noch nicht abgearbeitet und kann daher zurzeit nicht nochmals markiert werden."
      else
        @entry.delete_comment = params[:hint]
        @entry.save
        flash[:alert] = "Der Eintrag wurde markiert. Ein Moderator wird den Antrag pruefen und den Eintrag gegebenenfalls entfernen."
      end
      redirect_to @entry
    end
  end

  def keep
    @entry = Entry.find(params[:id])
    @entry.delete_comment = nil;
    @entry.save
    redirect_to @entry
  end

  def destroy_final
    destroy_entry
    redirect_to entries_path
  end

  def plan
    session[:plan_start] ||= []
    session[:plan_main] ||= []
    session[:plan_end] ||= []

    if params[:do] == 'add_start'
      unless session[:plan_start].include?(params[:id])
        session[:plan_start] << params[:id]
      end
    elsif params[:do] == 'add_main'
      unless session[:plan_main].include?(params[:id])
        session[:plan_main] << params[:id]
      end
    elsif params[:do] == 'add_end'
      unless session[:plan_end].include?(params[:id])
        session[:plan_end] << params[:id]
      end

    elsif params[:do] == 'del_start'
      session[:plan_start] -= [params[:id]]
    elsif params[:do] == 'del_main'
      session[:plan_main] -= [params[:id]]
    elsif params[:do] == 'del_end'
      session[:plan_end] -= [params[:id]]
    end

    redirect_to entries_path
  end

  def rate
    @entry = Entry.find(params[:id])

    if @entry.ratings.where(user: current_user).exists?
      flash[:error] = "Du hast diesen Eintrag bereits bewertet"
    else
      value = params[:rating].to_f
      if((value >= 1) && (value <= 5))
        @entry.ratings.create(user: current_user, value: value)
        @entry.rating = @entry.ratings.average(:value).round(2)
        @entry.save
        flash[:success] = "Bewertet mit #{params[:rating]} Sternen"
      end
    end

    redirect_to @entry
  end

  def not_published
    @entries_pub = Entry.where(published: false)
    @entries_del = Entry.where.not(delete_comment: nil)
    @programs_pub = Program.where(done: true, published: false)
    @programs_edit = Program.where.not(edited_title: nil)
    @program_entry_del = ProgramEntry.where.not(delete_comment: nil)
    @programs_del = Program.where.not(delete_comment: nil)
  end

  def publish
    @entry = Entry.find(params[:id])

    if @entry.edited_entry != nil
      @entry.id = @entry.edited_entry.id
      @entry.edited_entry.delete
      @entry.edited_entry = nil
    end

    @entry.update(published: true)
    flash[:success] = "Veroeffentlicht"
    @entry.programs.each do |program|
      program = update_program_attributes(program)
      program.save
    end
    redirect_to @entry
  end

  def tags
    @keywords = Entry.uniq.pluck(:keywords).collect {|x| x.split(/[\s,]/)}.flatten.uniq
    @keywords = @keywords.collect {|x| x.delete("'")}

    respond_to do |format|
      format.json { render json: @keywords }
    end
  end

  private
    def entry_params
      params.require(:entry).permit(:title,
                                    :title_other,
                                    :description,
                                    :material,
                                    :remarks,
                                    :preparation,
                                    :keywords,
                                    :part_start,
                                    :part_main,
                                    :part_end,
                                    :indoors,
                                    :outdoors,
                                    :weather_snow,
                                    :weather_rain,
                                    :weather_sun,
                                    :act_active,
                                    :act_calm,
                                    :act_creative,
                                    :group_size_min,
                                    :group_size_max,
                                    :age_min,
                                    :age_max,
                                    :time_min,
                                    :time_max,
                                    :cat_pocket,
                                    :cat_craft,
                                    :cat_cook,
                                    :cat_pioneer,
                                    :cat_night,
                                    :independent)
    end

    def program_entry_params
      params.require(:program_entry).permit(:program_id, :order)
    end

    def destroy_entry
      entry = Entry.find(params[:id])
      programs = []
      entry.programs.each do |program|
        programs << program.id
      end
      entry.destroy
      programs.each do |id|
        program = Program.find(id)
        program = update_program_attributes(program)
        program.save
      end
    end

    def authorize_entry_owner(entry)
      raise AuthorizationError unless entry_owner?(entry)
    end
end
