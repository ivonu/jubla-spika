class Picture < ActiveRecord::Base
  has_attached_file :file, styles: { thumb: "300x75>" }
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/
end
