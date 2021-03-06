class UsersController < ApplicationController
  before_action :require_signin, except: [:new, :create]
  #before_action :require_correct_user, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]  
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]

  
  def index
    #@users = User.all
    @users = User.not_admins
  end

  def show
    # Moved to set_user
    #@user = User.find(params[:id])
    @reviews = @user.reviews
    @favorite_movies = @user.favorite_movies
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thanks for signing up!"
      session[:intended_url] = nil
    else
      render :new
    end
  end

  def edit
    # Moved to set_user
    #@user = User.find(params[:id])
  end

  def update
    # Moved to set_user
    #@user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Account successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    # Moved to set_user
    #@user = User.find(params[:id])
    @user.destroy
    # Don't automatically sign out admin after deleting a user.
    #session[:user_id] = nil
    redirect_to root_path, alert: "Account successfully deleted!"
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :username)    
  end  

  def set_user
    #@user = User.find(params[:id])
    @user = User.find_by(username: params[:id])
  end

  def require_correct_user
    redirect_to root_url unless current_user?(@user)
  end

end
