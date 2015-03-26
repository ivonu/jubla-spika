class Program < ActiveRecord::Base
  before_destroy :destroy_entries

  has_many :program_entries, dependent: :destroy
  has_many :entries, through: :program_entries
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user

  validates :title, presence: true

  private
    def destroy_entries
      entries.each do |e|
        if not e.independent
          e.destroy
        end
      end
    end
end
