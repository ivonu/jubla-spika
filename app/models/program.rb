class Program < ActiveRecord::Base
  has_many :program_entries, dependent: :destroy
  has_many :entries, through: :program_entries
  has_many :ratings

  validates :title, presence: true
end
