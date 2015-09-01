class RemoveAwcFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :age_min
    remove_column :entries, :age_max
    remove_column :entries, :weather_snow
    remove_column :entries, :weather_rain
    remove_column :entries, :weather_sun
    remove_column :entries, :cat_pocket
    remove_column :entries, :cat_craft
    remove_column :entries, :cat_cook
    remove_column :entries, :cat_pioneer
    remove_column :entries, :cat_night
  end
end
