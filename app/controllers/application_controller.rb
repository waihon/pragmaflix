class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types(:danger)

private  

  def require_signin
    unless current_user
      #redirect_to new_session_url, alert: "Please sign in first!"
      session[:intended_url] = request.url
      redirect_to signin_url, alert: "Please sign in first!"
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user  

  def current_user?(user)
    current_user == user
  end

  helper_method :current_user?

  def require_admin
    redirect_to root_url, alert: "Unauthorized access!" unless current_user_admin?
  end

  def current_user_admin?
    current_user && current_user.admin?
  end

  helper_method :current_user_admin?

end
