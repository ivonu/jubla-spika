class AddAgcToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :age_5, :boolean
    add_column :entries, :age_8, :boolean
    add_column :entries, :age_12, :boolean
    add_column :entries, :age_15, :boolean
    add_column :entries, :age_17, :boolean
    add_column :entries, :act_talk, :boolean
    add_column :entries, :cat_game, :boolean
    add_column :entries, :cat_shape, :boolean
    add_column :entries, :cat_group, :boolean
    add_column :entries, :cat_jubla, :boolean
  end
end
