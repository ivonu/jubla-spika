class CreateProgramEntries < ActiveRecord::Migration
  def change
    create_table :program_entries do |t|
      t.belongs_to :entry, index: true
      t.belongs_to :program, index: true

      t.integer :order

      t.timestamps null: false
    end
  end
end
