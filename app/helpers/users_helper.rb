module UsersHelper
  def get_role_label (role)
    color = {
        :user      => 'default',
        :moderator => 'primary',
        :admin     => 'danger'
    }[role.to_sym]

    ('<span class="label label-' + color + '">' + role + '</span>').html_safe
  end

  def get_updatable_roles (user)
    User.roles.select { |a| a.to_i <= user.role.to_int }
  end
end
