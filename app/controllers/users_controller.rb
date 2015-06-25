class UsersController < ApplicationController

  before_action :authorize_moderator, only: :index

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    if not @user == current_user
      authorize_moderator
    end
  end

  def update
    @user = User.find(params[:id])
    if not @user == current_user
      authorize_moderator
    end

    if current_user.is_moderator? or @user.valid_password?(params[:user][:current_password])
      if params[:user][:role] != nil and params[:user][:role] != @user.role
        @user.role = params[:user][:role]
        authorize_update(@user)
      end
      if @user == current_user or current_user.is_admin?
        if @user.update(params[:user][:password] == "" ? user_params : user_params_pwd)
          flash[:success] = "Der Benutzer wurde geaendert"
          redirect_to @user
        else
          render 'edit'
        end
      else
        flash[:success] = "Der Benutzer wurde geaendert"
        redirect_to @user
      end
    else
      @user.errors.add(:current_password, "Dein Passwort stimmt nicht")
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if not user == current_user
      authorize_admin
    end
    user.destroy
    flash[:success] = 'Der Benutzer wurde entfernt'
    if current_user == user
      redirect_to root_path
    else
      redirect_to users_url
    end
  end

  private
    def authorize_update (user)
      raise AuthorizationError unless current_user.is_admin? or
                                      (current_user.is_moderator? and
                                          user.role != 'admin' and
                                          user.role_was != 'admin')
    end
    def user_params
      params.require(:user).permit( :first_name,
                                    :last_name,
                                    :name,
                                    :email)
    end
    def user_params_pwd
      params.require(:user).permit( :first_name,
                                    :last_name,
                                    :name,
                                    :email,
                                    :password,
                                    :password_confirmation)
    end

end
