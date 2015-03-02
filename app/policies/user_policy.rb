class UserPolicy < ApplicationPolicy

  def index?
    user.admin? or user.moderator?
  end

  def update?
    user.admin? or (user.moderator? and
                    User.roles[record.role] != User.roles[:admin] and
                    User.roles[record.role_was] != User.roles[:admin])
  end

  def destroy?
    user.admin?
  end
end