class UserPolicy < ApplicationPolicy

  def index?
    user.admin? || user.moderator?
  end

  def update_role?
    user.admin? || (user.moderator? && !record.admin?)
  end
end