class AddActcontact < ActiveRecord::Migration
  def change
    add_column :programs, :act_distance, :boolean
    add_column :entries, :act_distance, :boolean
  end
end
