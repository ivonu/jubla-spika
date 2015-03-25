class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :text
      t.belongs_to :entry, index: true
      t.belongs_to :program, index: true
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
