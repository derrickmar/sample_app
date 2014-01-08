class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # redirects to show page
    else
      render 'new'
    end
  end

  def edit
    # we don't need to have @user = User.find(params[:id]) anymore
    # because the method correct_user handles it for us. Remember
    # correct_user method is called first because of the
    # before_action.
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      sign_in @user
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end


  # all methods below this a private
  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    # unless the user equals the current user (which is identified by
    # the cookie and token) then redirect to the root_url. This is
    # really only implemented for malicious intent because a user that
    # is signed in is writing a link that like ~/users/3/edit and
    # trying to edit another users information
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
