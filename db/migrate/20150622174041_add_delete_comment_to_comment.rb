class AddDeleteCommentToComment < ActiveRecord::Migration
  def change
    add_column :comments, :delete_comment, :string
  end
end
