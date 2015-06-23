class AddDeleteUserToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :delete_user, :integer
  end
end
