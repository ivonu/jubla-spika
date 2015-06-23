class CommentsController < ApplicationController

  before_action :authorize_user
  before_action :authorize_moderator, only: [:publish, :destroy_final, :keep]

  def create
    flash[:alert] = "Der Kommentar muss noch von einem Moderator veroeffentlicht werden, bis er hier erscheint."
    if params.has_key?(:entry_id)
      @entry = Entry.find(params[:entry_id])
      @comment = @entry.comments.new(comment_params)
      @comment.user = current_user
      @comment.published = false
      @comment.save
      redirect_to entry_path(@entry)
    else 
      @program = Program.find(params[:program_id])
      @comment = @program.comments.new(comment_params)
      @comment.user = current_user
      @comment.published = false
      @comment.save
      redirect_to program_path(@program)
    end
  end

  def publish
    comment = Comment.find(params[:id])
    comment.published = true
    comment.save
    if not comment.entry == nil
      redirect_to comment.entry
    else
      redirect_to comment.program
    end
  end

  def keep
    comment = Comment.find(params[:id])
    comment.delete_comment = nil;
    comment.save
    if not comment.entry == nil
      redirect_to comment.entry
    else
      redirect_to comment.program
    end
  end

  def destroy
    comment = Comment.find(params[:comment_id])
    if not comment.published
      if current_user.is_moderator?
        comment.destroy
      end
    else
      if comment.delete_comment != nil
        flash[:error] = "Dieser Kommentar wurde bereits zum entfernen markiert, aber noch nicht abgearbeitet und kann daher zurzeit nicht nochmals markiert werden."
      else
        comment.delete_comment = params[:hint]
        comment.delete_user = current_user
        comment.save
        flash[:alert] = "Der Kommentar wurde markiert. Ein Moderator wird den Antrag pruefen und den Kommentar gegebenenfalls entfernen."
      end
    end
    if not comment.entry == nil
      redirect_to comment.entry
    else
      redirect_to comment.program
    end
  end

  def destroy_final
    comment = Comment.find(params[:id])
    if not comment.entry == nil
      @entry = comment.entry
      comment.destroy
      redirect_to @entry
    else
      @program = comment.program
      comment.destroy
      redirect_to @program
    end
  end
 
  private
    def comment_params
      params.require(:comment).permit(:text)
    end

end
