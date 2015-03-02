class ProgramEntry < ActiveRecord::Base
  belongs_to :entry
  belongs_to :program

  validates_associated :entry
  validates_associated :program
end
