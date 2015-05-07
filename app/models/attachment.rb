class Attachment < ActiveRecord::Base
  belongs_to :entry

  has_attached_file :file,
    styles: lambda{ |a|
      %w(image/jpeg image/png image/jpg image/gif).include?(a.content_type) ?
          { :thumb=> "100x100#", } :
          { }
    }

  validates_attachment_content_type :file, content_type: %w(application/pdf
                                                            image/gif
                                                            image/jpg
                                                            image/jpeg
                                                            image/png
                                                            text/plain
                                                            text/rtf
                                                            application/vnd.ms-excel
                                                            application/msword
                                                            application/vnd.openxmlformats-officedocument.wordprocessingml.document
                                                            application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)
end
