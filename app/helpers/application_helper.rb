module ApplicationHelper
  def bootstrap_class_for (flash_type)
    case flash_type
      when 'success'
        'success'
      when 'error'
        'danger'
      when 'alert'
        'warning'
      when 'notice'
        'info'
      else
        flash_type.to_s
    end
  end
end
