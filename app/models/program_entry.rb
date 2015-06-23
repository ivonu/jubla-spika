class ProgramEntry < ActiveRecord::Base
  belongs_to :entry
  belongs_to :program
  belongs_to :delete_user, :class_name => 'User', :foreign_key => 'delete_user'

  validates_associated :entry
  validates_associated :program
end
