class Rating < ActiveRecord::Base

  belongs_to :entry
  belongs_to :program
  belongs_to :user

end
