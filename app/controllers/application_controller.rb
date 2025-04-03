class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this section"
      redirect_to login_path
    end
  end
  
  # Alias for require_login to match naming convention used in controllers
  alias authenticate_user! require_login

  def require_creator
    unless current_user&.is_a?(Creator)
      flash[:alert] = "You must be a creator to access this section"
      redirect_to root_path
    end
  end

  def require_backer
    unless current_user&.is_a?(Backer)
      flash[:alert] = "You must be a backer to access this section"
      redirect_to root_path
    end
  end
end
