class AddDeleteCommentToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :delete_comment, :string
  end
end
