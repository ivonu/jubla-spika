class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.attachment :file
      t.timestamps null: false
    end
  end
end
