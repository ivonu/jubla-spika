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

end
