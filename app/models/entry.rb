class Entry < ActiveRecord::Base
  has_many :program_entries
  has_many :programs, through: :program_entries
end
