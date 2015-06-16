class AddDoneToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :done, :boolean
  end
end
