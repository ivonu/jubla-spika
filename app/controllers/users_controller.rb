class UsersController < ApplicationController

  before_action :authenticate_user!

  def index
    authorize User
    @users = User.all
  end


  def show
    @user = User.find(params[:id])
  end


  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    @user.role = params[:user][:role]

    authorize @user

    if @user.update_attributes(user_params)
      flash[:success] = 'User updated'
      redirect_to @user
    else
      render 'edit'
    end
  end


  def destroy
    user = User.find(params[:id])
    authorize user

    user.destroy
    flash[:success] = 'User deleted.'
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :role)
    end
end
