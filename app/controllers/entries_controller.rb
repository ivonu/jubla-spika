class EntriesController < ApplicationController

  before_filter :authenticate_user!, :only => :rate

  def index

    @plan_start = (session[:plan_start] == nil) ? [] : session[:plan_start]
    @plan_main = (session[:plan_main] == nil) ? [] : session[:plan_main]
    @plan_end = (session[:plan_end] == nil) ? [] : session[:plan_end]
    @plan = (@plan_start.size() != 0) || (@plan_main.size() != 0) || (@plan_end.size() != 0)

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

    @entries = @filterrific.find.where(independent: true).paginate(:page => params[:page], :per_page => 20)
    @shown_programs = []
    @hide_programs = false
    @only_programs = false
    if params[:filterrific] != nil
      if params[:filterrific]["with_part_start"] == "1" then @hide_programs = true end
      if params[:filterrific]["with_part_main"] == "1" then @hide_programs = true end
      if params[:filterrific]["with_part_end"] == "1" then @hide_programs = true end
      if params[:filterrific]["only_programs"] == "1"
        @only_programs = true
        @programs = []
        @filterrific.find.each do |entry|
          entry.programs.each do |program|
            @programs << program unless @programs.include?(program)
          end
        end
        @programs = @programs.paginate(:page => params[:page], :per_page => 20)
      end
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

  def new
    @entry = Entry.new()
  end

  def create
    @entry = Entry.new(entry_params)
    @program_entry = ProgramEntry.new(program_entry_params) if params[:program_entry].present?

    if @entry.save

      if params[:entry][:attachments]
        params[:entry][:attachments].each { |attachment|
          @entry.attachments.create(file: attachment)
        }
      end

      if @program_entry
        @program_entry.entry = @entry
        if @program_entry.save
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
  end

  def update
    @entry = Entry.find(params[:id])
   
    if @entry.update(entry_params)
      redirect_to @entry
    else
      render 'edit'
    end
  end


  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
   
    redirect_to entries_path
  end

  def plan
    if params[:do] == 'add_start'
      unless (session[:plan_start] ||= []).include?(params[:entry]) 
        session[:plan_start] << params[:entry]
      end
    elsif params[:do] == 'add_main'
      unless (session[:plan_main] ||= []).include?(params[:entry]) 
        session[:plan_main] << params[:entry]
      end
    elsif params[:do] == 'add_end'
      unless (session[:plan_end] ||= []).include?(params[:entry]) 
        session[:plan_end] << params[:entry]
      end

    elsif params[:do] == 'del_start'
      session[:plan_start] -= [params[:entry]]
    elsif params[:do] == 'del_main'
      session[:plan_main] -= [params[:entry]]
    elsif params[:do] == 'del_end'
      session[:plan_end] -= [params[:entry]]
    end

    redirect_to entries_path
  end

  def rate
    @entry = Entry.find(params[:entry])

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

    redirect_to Entry.find(params[:entry])
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
                                    :independent)
    end

    def program_entry_params
      params.require(:program_entry).permit(:program_id, :order)
    end
end
