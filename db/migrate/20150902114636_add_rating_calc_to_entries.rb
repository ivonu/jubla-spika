class AddRatingCalcToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :rating_calc, :float
  end
end
