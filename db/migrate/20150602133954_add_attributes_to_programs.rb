class AddAttributesToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :search_text, :text
    add_column :programs, :material, :text
    add_column :programs, :remarks, :text
    add_column :programs, :preparation, :text
    add_column :programs, :indoors, :boolean
    add_column :programs, :outdoors, :boolean
    add_column :programs, :weather_snow, :boolean
    add_column :programs, :weather_rain, :boolean
    add_column :programs, :weather_sun, :boolean
    add_column :programs, :act_active, :boolean
    add_column :programs, :act_calm, :boolean
    add_column :programs, :act_creative, :boolean
    add_column :programs, :group_size_min, :integer
    add_column :programs, :group_size_max, :integer
    add_column :programs, :age_min, :integer
    add_column :programs, :age_max, :integer
    add_column :programs, :time_min, :integer
    add_column :programs, :time_max, :integer
    add_column :programs, :cat_pocket, :boolean
    add_column :programs, :cat_craft, :boolean
    add_column :programs, :cat_cook, :boolean
    add_column :programs, :cat_pioneer, :boolean
    add_column :programs, :cat_night, :boolean
  end
end
