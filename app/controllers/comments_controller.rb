class CommentsController < ApplicationController

  before_filter :authorize_user

  def create
    if params.has_key?(:entry_id)
      @entry = Entry.find(params[:entry_id])
      @comment = @entry.comments.new(comment_params)
      @comment.user = current_user
      @comment.save
      redirect_to entry_path(@entry)
    else 
      @program = Program.find(params[:program_id])
      @comment = @program.comments.new(comment_params)
      @comment.user = current_user
      @comment.save
      redirect_to program_path(@program)
    end

  end
 
  private
    def comment_params
      params.require(:comment).permit(:text)
    end

end
