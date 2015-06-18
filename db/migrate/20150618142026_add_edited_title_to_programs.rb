class AddEditedTitleToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :edited_title, :string
  end
end
