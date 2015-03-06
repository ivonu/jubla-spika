class UserPolicy

  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def index?
    @current_user.is_moderator?
  end

  def show?
    @current_user.is_moderator?
  end

  def edit?
    @current_user.is_moderator?
  end

  def update?
    @current_user.is_admin? or
    (@current_user.is_moderator? and @user.role != 'admin' and @user.role_was != 'admin')
  end

  def destroy?
    @current_user.is_admin?
  end
end