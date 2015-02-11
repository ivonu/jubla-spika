class UserController < ApplicationController

  def index
    @user = User.find(3)
    @user.role = :user
    @user.save

    authorize User
    @users = User.all
  end

end
