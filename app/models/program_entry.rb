class ProgramEntry < ActiveRecord::Base
  belongs_to :entry
  belongs_to :program
end
