class UserController < ApplicationController

  before_action :authenticate_user!

  def index
    authorize User
    @users = User.all
  end

  def update_role
    user = User.find(params[:id])

    user.role = params[:user][:role]
    authorize user

    if user.save
      redirect_to users_path
    end
  end

end
