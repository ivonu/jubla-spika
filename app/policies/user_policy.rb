class UserPolicy < ApplicationPolicy

  def index?
    user.admin?
  end
end