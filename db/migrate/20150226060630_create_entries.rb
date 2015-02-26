class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.string :title_other
      t.text :description
      t.text :material
      t.text :remarks
      t.text :preparation
      t.text :keywords
      t.boolean :part_start
      t.boolean :part_main
      t.boolean :part_end
      t.boolean :indoors
      t.boolean :outdoor
      t.boolean :weather_snow
      t.boolean :weather_rain
      t.boolean :weather_sun
      t.boolean :act_active
      t.boolean :act_calm
      t.boolean :act_creative
      t.integer :group_size_min
      t.integer :group_size_max
      t.integer :age_min
      t.integer :age_max
      t.integer :time_min
      t.integer :time_max
      t.boolean :independent

      t.timestamps null: false
    end
  end
end
