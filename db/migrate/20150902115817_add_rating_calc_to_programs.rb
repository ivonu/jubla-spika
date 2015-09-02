class AddRatingCalcToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :rating_calc, :float
  end
end
