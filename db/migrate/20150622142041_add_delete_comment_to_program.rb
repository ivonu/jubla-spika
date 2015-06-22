class AddDeleteCommentToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :delete_comment, :string
  end
end
