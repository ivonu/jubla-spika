class UsersController < ApplicationController

  before_action :authenticate_user!

  def index
    authorize User
    @users = User.all
  end


  def show
    @user = User.find(params[:id])
    authorize @user
  end


  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])

    @user.role = params[:user][:role]
    authorize @user

    if @user.save
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
end
