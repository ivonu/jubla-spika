class RemoveAwcFromPrograms < ActiveRecord::Migration
  def change
    remove_column :programs, :age_min
    remove_column :programs, :age_max
    remove_column :programs, :weather_snow
    remove_column :programs, :weather_rain
    remove_column :programs, :weather_sun
    remove_column :programs, :cat_pocket
    remove_column :programs, :cat_craft
    remove_column :programs, :cat_cook
    remove_column :programs, :cat_pioneer
    remove_column :programs, :cat_night
  end
end
