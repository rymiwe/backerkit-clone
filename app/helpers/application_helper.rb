module ApplicationHelper
  def logged_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logout_path
    '/logout'
  end

  def login_path
    '/login'
  end

  def signup_path
    '/signup'
  end
end
