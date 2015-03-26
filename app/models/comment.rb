class Comment < ActiveRecord::Base

  belongs_to :entry
  belongs_to :program
  belongs_to :user

  validates :text, presence: true
  
end
