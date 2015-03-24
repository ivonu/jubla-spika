class AddRatingToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :rating, :float
  end
end
