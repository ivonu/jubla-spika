class Entry < ActiveRecord::Base
  has_many :program_entries
  has_many :programs, through: :program_entries

  validates :title, presence: true
  validates :description, presence: true
  validates :keywords, presence: true
  validates :group_size_min, presence: true, numericality: true
  validates :group_size_max, presence: true, numericality: true
  validates :age_min, presence: true, numericality: true
  validates :age_max, presence: true, numericality: true
  validates :time_min, presence: true, numericality: true
  validates :time_max, presence: true, numericality: true
  validates :independent, presence: true
end
