class News < ActiveRecord::Base

  validates :title, presence: true
  validates :text, presence: true
  before_validation :sanitize_content

  private
    def sanitize_content
      self.text = ActionController::Base.helpers.sanitize self.text
    end

end