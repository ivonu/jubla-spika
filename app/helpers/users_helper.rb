module UsersHelper
  def get_role_label (role)
    color = {
        :user      => 'default',
        :writer    => 'default',
        :moderator => 'primary',
        :admin     => 'danger'
    }[role.to_sym]

    ('<span class="label label-' + color + '">' + role + '</span>').html_safe
  end
end
