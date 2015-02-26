class Program < ActiveRecord::Base
  has_many :program_entries
  has_many :entries, through: :program_entries
end
