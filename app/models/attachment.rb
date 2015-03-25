class Attachment < ActiveRecord::Base
  belongs_to :entry

  has_attached_file :file
  validates_attachment_content_type :file, content_type: ['application/pdf',
                                                          'image/gif',
                                                          'image/jpeg',
                                                          'image/png',
                                                          'text/plain',
                                                          'text/rtf',
                                                          'application/vnd.ms-excel',
                                                          'application/msword',
                                                          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                                                          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
end
