class EntriesController < ApplicationController

  def index
    @entries = Entry.all
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
                                    :time_max)
    end

    

end
