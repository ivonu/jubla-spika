class AttachmentsController < ApplicationController

  def create
    @attachment = Attachment.create(file: params[:file], entry: Entry.find(params[:entry_id]))

    if @attachment.new_record?
      flash[:error] = "Fehler beim Dateiupload!"
    end
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @entry = @attachment.entry
    @attachment.destroy

    redirect_to @entry
  end
end
