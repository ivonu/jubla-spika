class PicturesController < ApplicationController

  before_filter :authorize_admin

  def index
    @pictures = Picture.all.reverse
    @picture = Picture.new
  end

  def create
    if params[:picture][:file]
      params[:picture][:file].each do |file|
        @picture = Picture.create(file: file)
        if @picture.new_record?
          flash[:error] = "Fehler beim Dateiupload!"
        end
      end
    end
    redirect_to pictures_path
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
   
    redirect_to pictures_path
  end

end
