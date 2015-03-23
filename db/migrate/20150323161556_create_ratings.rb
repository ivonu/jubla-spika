class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :value
      t.belongs_to :entry, index: true
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
