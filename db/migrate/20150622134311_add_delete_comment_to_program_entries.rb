class AddDeleteCommentToProgramEntries < ActiveRecord::Migration
  def change
    add_column :program_entries, :delete_comment, :string
  end
end
