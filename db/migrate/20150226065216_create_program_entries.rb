class CreateProgramEntries < ActiveRecord::Migration
  def change
    create_table :program_entries do |t|
      t.integer :order

      t.timestamps null: false
    end
  end
end
