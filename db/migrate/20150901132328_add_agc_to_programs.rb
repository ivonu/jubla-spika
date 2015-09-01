class AddAgcToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :age_5, :boolean
    add_column :programs, :age_8, :boolean
    add_column :programs, :age_12, :boolean
    add_column :programs, :age_15, :boolean
    add_column :programs, :age_17, :boolean
    add_column :programs, :act_talk, :boolean
    add_column :programs, :cat_game, :boolean
    add_column :programs, :cat_shape, :boolean
    add_column :programs, :cat_group, :boolean
    add_column :programs, :cat_jubla, :boolean
  end
end
