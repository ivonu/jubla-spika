class AddDeleteUserToComments < ActiveRecord::Migration
  def change
    add_column :comments, :delete_user, :integer
  end
end
