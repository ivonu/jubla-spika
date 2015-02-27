class EntriesController < ApplicationController

  def index
    @entries = Entry.all
  end

  def new
    @entry = Entry.new()
  end

  def create
    @entry = Entry.new(entry_params)

    @entry.save
    redirect_to @entry
  end

  def show
    @entry = Entry.find(params[:id])
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
