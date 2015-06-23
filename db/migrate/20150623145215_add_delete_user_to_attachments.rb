class AddDeleteUserToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :delete_user, :integer
  end
end
