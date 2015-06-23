class Comment < ActiveRecord::Base

  belongs_to :entry
  belongs_to :program
  belongs_to :user
  belongs_to :delete_user, :class_name => 'User', :foreign_key => 'delete_user'

  validates :text, presence: true
  
end
