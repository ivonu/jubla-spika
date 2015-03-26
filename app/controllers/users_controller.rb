class UsersController < ApplicationController

  before_action :authorize_moderator
  before_action :authorize_admin, only: :destroy

  def index
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

    authorize_update(@user)

    if @user.save
      flash[:success] = 'User updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = 'User deleted.'
    redirect_to users_url
  end

  private
  def authorize_update (user)
    raise AuthorizationError unless current_user.is_admin? or
                                    (current_user.is_moderator? and
                                        user.role != 'admin' and
                                        user.role_was != 'admin')
  end

end
