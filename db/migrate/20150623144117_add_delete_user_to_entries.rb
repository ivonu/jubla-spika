class AddDeleteUserToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :delete_user, :integer
  end
end
