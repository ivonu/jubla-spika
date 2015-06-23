class AddDeleteUserToProgramEntries < ActiveRecord::Migration
  def change
    add_column :program_entries, :delete_user, :integer
  end
end
