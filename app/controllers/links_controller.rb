class LinksController < ApplicationController

  before_filter :authorize_admin

  def index
    @links = Link.all()
  end

  def show
    @link = Link.find(params[:id])
  end

  def new
    @link = Link.new()
  end

  def create
    @link = Link.new(links_params)
    @link.url = cleaned_link(@link.url)

    if @link.save
      redirect_to @link
    else
      render 'new'
    end
  end

  def edit
    @link = Link.find(params[:id])
  end

  def update
    @link = Link.find(params[:id])
    @link.update_attributes(links_params)
    @link.url = cleaned_link(@link.url)
   
    if @link.save
      redirect_to @link
    else
      render 'edit'
    end
  end

  def destroy
    @link = Link.find(params[:id])
    @link.destroy
   
    redirect_to links_path
  end

  private
    def links_params
      params.require(:link).permit(:title, :url)
    end

    def cleaned_link (url)
      if url[0..6] != "http://" and url[0..7] != "https://"
        url = "http://#{url}"
      end
      return url
    end
end
