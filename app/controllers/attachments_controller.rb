class AttachmentsController < ApplicationController

  def destroy
    @attachment = Attachment.find(params[:id])
    @entry = @attachment.entry
    @attachment.destroy

    redirect_to @entry
  end
end
