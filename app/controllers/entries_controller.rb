class EntriesController < ApplicationController

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

    respond_to do |format|
      format.html
      format.js
    end

    rescue ActiveRecord::RecordNotFound => e
      puts "Ein Fehler ist aufgetreten und der Filter wurde zurueckgesetzt: #{ e.message }"
      redirect_to(reset_filterrific_url(format: :html)) and return

  end

  def new
    @entry = Entry.new()
  end

  def create
    @entry = Entry.new(entry_params)

    if @entry.save
      redirect_to @entry
    else
      render 'new'
    end
  end

  def show
    @entry = Entry.find(params[:id])
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

    redirect_to entries_path
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

end
