class ProgramsController < ApplicationController

  before_action :authorize_user, except: [:show, :plan]
  before_action :authorize_moderator, only: [:publish, :keep, :destroy_final]
  
  def show
    @edit = false;
    @show_done = false

    if params[:id].to_i == 0

      @edit = true
      @plan = true
      @program = Program.new
      @program.id = 0
      @program.title = "Deine Gruppenstunde"

      @plan_start = []
      @plan_main = []
      @plan_end = []

      session[:plan_start].each do |id|
        entry = Entry.find(id)
        @program.entries << entry
        @plan_start << entry
      end
      session[:plan_main].each do |id|
        entry = Entry.find(id)
        @program.entries << entry
        @plan_main << entry
      end
      session[:plan_end].each do |id|
        entry = Entry.find(id)
        @program.entries << entry
        @plan_end << entry
      end

      @program = update_program_attributes(@program)

    else
      @plan = false
      @program = Program.find(params[:id])
      if not @program.done
        authorize_program_owner @program
        @show_done = true;
      end
    end

    @attachments = @program.entries.collect{|x| x.attachments.order(:file_content_type)}.flatten

    if params[:edit] or not @program.done
      @edit = true;
    end

    if user_signed_in? and current_user.is_moderator?
      if not @program.edited_title == nil
        @program.title = "#{@program.edited_title} (bisher: #{@program.title})"
      end
    end

    respond_to do |format|
      format.html
      format.pdf do
        render  :pdf => "Spika_Program",
                :template => 'programs/show.pdf.erb',
                :page_size => 'A4',
                :footer => {:left => "spika.jubla.ch", :center => "Spielkatapult", :right => 'Seite [page] von [topage]' }
      end
    end
  end

  def new
    @program = Program.new
  end

  def new_entry
    @entry = Entry.new
    program = Program.find(params[:program_id])

    order = params[:order].to_i
    last_program_entry = ProgramEntry.where(program: program).where(order: (order..(order+99))).order(:order).last
    order = last_program_entry.order+1 if last_program_entry
    @program_entry = ProgramEntry.new(program: program, order: order)

    render 'entries/new'
  end

  def create
    @program = Program.new(program_params)
    @program.user = current_user
    @program.search_text = ""
    @program.material = ""
    @program.preparation = ""
    @program.remarks = ""
    @program.group_size_min = 0
    @program.group_size_max = 0
    @program.age_min = 0
    @program.age_max = 0
    @program.time_min = 0
    @program.time_max = 0
    @program.indoors = false
    @program.outdoors = false
    @program.weather_snow = false
    @program.weather_rain = false
    @program.weather_sun = false
    @program.act_active = false
    @program.act_calm = false
    @program.act_creative = false
    @program.cat_pocket = false
    @program.cat_craft = false
    @program.cat_cook = false
    @program.cat_pioneer = false
    @program.cat_night = false
    @program.done = false
    @program.published = false

    if @program.save
      flash[:info] = "Gruppenstunde erstellt. Du kannst nun neue Spiele erfassen oder bestehende verwenden. Sobald du fertig bist, kannst du auf den Knopf 'Fertig' druecken."
      redirect_to @program
    else
      render 'new'
    end
  end
  
  def edit
    @program = Program.find(params[:id])
  end

  def done
    @program = Program.find(params[:id])
    authorize_program_owner @program
    @program.done = true
    @program.save
    flash[:info] = "Deine Gruppenstunde muss nun noch von einem Moderator freigeschaltet werden, dann ist sie online."
    redirect_to @program
  end

  def publish
    @program = Program.find(params[:id])

    not_ok = nil;
    @program.entries.each do |entry|
      if not entry.published then not_ok = entry.title; end
    end

    if not_ok == nil
      @program.published = true;
      if not @program.edited_title == nil
        @program.title = @program.edited_title
        @program.edited_title = nil
      end
      @program.save
      flash[:success] = "Veroeffentlicht"
    else
      flash[:error] = "Das Spiel #{not_ok} gehoert zu dieser Gruppenstunde, wurde aber noch nicht veroeffentlicht. Darum kann die Gruppenstunde auch noch nicht veroeffentlicht werden."
    end
    redirect_to @program
  end

  def update
    @program = Program.find(params[:id])

    if not @program.published
      if not @program.done
        authorize_program_owner @program
      else
        if not current_user.is_moderator?
          authorize_program_owner @program
        end
      end
      @program.title = params[:program][:title]
      if @program.save
        redirect_to @program
      else
        render 'edit'
      end
    else
      if not @program.edited_title == nil
        flash[:error] = "Der Titel wurde bereits bearbeitet, die Aenderung aber noch nicht akzeptiert. Deshalb kann der Titel zurzeit nicht nochmals bearbeitet werden."
        redirect_to @program
      else
        @program.edited_title = params[:program][:title]

        if @program.save
          flash[:info] = "Deine Aenderung muss noch von einem Moderator ueberprueft werden, bevor sie veroeffentlicht wird."
          redirect_to @program
        else
          render 'edit'
        end
      end
    end
  end

  def destroy
    @program = Program.find(params[:id])
    if not @program.published
      if not @program.done
        authorize_program_owner @program
      else
        if not current_user.is_moderator?
          authorize_program_owner @program
        end
      end
      destroy_program
      redirect_to entries_path
    else
      @program = Program.find(params[:id])
      if @program.delete_comment != nil
        flash[:error] = "Diese Gruppenstunde wurde bereits zum entfernen markiert, aber noch nicht abgearbeitet und kann daher zurzeit nicht nochmals markiert werden."
      else
        @program.delete_comment = params[:hint]
        @program.save
        flash[:alert] = "Die Gruppenstunde wurde markiert. Ein Moderator wird den Antrag pruefen und sie gegebenenfalls entfernen."
      end
      redirect_to @program
    end
  end

  def keep
    @program = Program.find(params[:id])
    @program.delete_comment = nil;
    @program.save
    redirect_to @program
  end

  def destroy_final
    destroy_program
    redirect_to entries_path
  end

  def rate
    @program = Program.find(params[:id])

    if @program.ratings.where(user: current_user).exists?
      flash[:error] = "Du hast diesen Eintrag bereits bewertet"
    else
      value = params[:rating].to_f
      if((value >= 1) && (value <= 5))
        @program.ratings.create(user: current_user, value: value)
        @program.rating = @program.ratings.average(:value).round(2)
        @program.save
        flash[:success] = "Bewertet mit #{params[:rating]} Sternen"
      end
    end

    redirect_to @program
  end

  private
    def program_params
      params.require(:program).permit(:title)
    end

    def destroy_program
      program = Program.find(params[:id])
      program.entries.each do |entry|
        if entry.programs.count == 1 and not entry.independent
          entry.destroy
        end
      end
      program.destroy
    end

    def authorize_program_owner (program)
      raise AuthorizationError unless program_owner?(program)
    end
end
