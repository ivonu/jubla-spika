class AddProgramsToRatings < ActiveRecord::Migration
  def change
    add_reference :ratings, :program, index: true
    add_foreign_key :ratings, :programs
  end
end
