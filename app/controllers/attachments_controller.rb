class AttachmentsController < ApplicationController

  before_action :authorize_user
  before_action :authorize_moderator, only: [:keep, :destroy_final]

  def destroy
    @attachment = Attachment.find(params[:attach_id])
    if @attachment.delete_comment != nil
      flash[:error] = "Dieser Anhang wurde bereits zum entfernen markiert, aber noch nicht abgearbeitet und kann daher zurzeit nicht nochmals markiert werden."
    else
      @attachment.delete_comment = params[:hint]
      @attachment.delete_user = current_user
      @attachment.save
      flash[:alert] = "Der Anhang wurde markiert. Ein Moderator wird den Antrag pruefen und den Anhang gegebenenfalls entfernen."
    end

    redirect_to @attachment.entry
  end

  def destroy_final
    @attachment = Attachment.find(params[:id])
    @entry = @attachment.entry
    @attachment.destroy

    redirect_to @entry
  end

  def keep
    @attachment = Attachment.find(params[:id])
    @attachment.delete_comment = nil;
    @attachment.save
    redirect_to @attachment.entry
  end

end
