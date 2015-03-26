class AddPublishedToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :published, :boolean
  end
end
