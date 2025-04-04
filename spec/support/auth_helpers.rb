module AuthHelpers
  # Simulates signing in a user in controller tests
  def sign_in(user)
    session[:user_id] = user.id
  end
  
  # Simulates signing out in controller tests
  def sign_out
    session[:user_id] = nil
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :controller
  config.include AuthHelpers, type: :request
  config.include AuthHelpers, type: :system
end
