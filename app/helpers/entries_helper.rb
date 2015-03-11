module EntriesHelper

  def checked_glyphicons (value)

    if value then
      icon = "ok"
    else
      icon = "remove"
    end

    data = "<span class='glyphicon glyphicon-#{icon} aria-hidden='true'></span>"
    data.html_safe

  end

  def print_time (value)

    if value > 60
      "#{value/60} Stunden".html_safe
    elsif value == 60
      "1 Stunde".html_safe
    else
      "#{value} Minuten".html_safe
    end
    
  end

end
