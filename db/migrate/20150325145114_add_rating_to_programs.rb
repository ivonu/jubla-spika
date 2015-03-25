class AddRatingToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :rating, :float
  end
end
