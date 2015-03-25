class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.belongs_to  :entry, index: true
      t.timestamps null: false
    end
  end
end
