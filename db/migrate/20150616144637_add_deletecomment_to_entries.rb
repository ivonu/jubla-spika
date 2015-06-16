class AddDeletecommentToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :delete_comment, :string
  end
end
