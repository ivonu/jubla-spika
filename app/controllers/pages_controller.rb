class PagesController < ApplicationController

  before_filter :authorize_admin

  def index
    @pages = Page.all()
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])   
    if @page.update(page_params)
      redirect_to pages_path
    else
      render 'edit'
    end
  end

  private
    def page_params
      params.require(:page).permit(:text)
    end
end
