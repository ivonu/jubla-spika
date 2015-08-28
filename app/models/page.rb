class Page < ActiveRecord::Base

  before_validation :sanitize_content

  private
    def sanitize_content
      self.text = ActionController::Base.helpers.sanitize self.text
    end
    
end
