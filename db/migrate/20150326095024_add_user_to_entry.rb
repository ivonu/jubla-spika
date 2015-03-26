class AddUserToEntry < ActiveRecord::Migration
  def change
    add_reference :entries, :user, index: true
    add_foreign_key :entries, :users

    add_reference :programs, :user, index: true
    add_foreign_key :programs, :users
  end
end
