class AddEditedEntryToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :edited_entry, :integer
  end
end
