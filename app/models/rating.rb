class Rating < ActiveRecord::Base

  belongs_to :entry
  belongs_to :user

end
