class AddCategoriesToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :cat_pocket, :boolean
    add_column :entries, :cat_craft, :boolean
    add_column :entries, :cat_cook, :boolean
    add_column :entries, :cat_pioneer, :boolean
    add_column :entries, :cat_night, :boolean
  end
end
