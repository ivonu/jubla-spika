module UsersHelper
  def get_role_label (role)
    color = {
        :user      => 'default',
        :writer    => 'default',
        :moderator => 'primary',
        :admin     => 'danger'
    }[role.to_sym]
    german = {
        :user      => 'Benutzer',
        :writer    => 'Schreiber',
        :moderator => 'Moderator',
        :admin     => 'Administrator'
    }[role.to_sym]

    ('<span class="label label-' + color + '">' + german + '</span>').html_safe
  end
end
