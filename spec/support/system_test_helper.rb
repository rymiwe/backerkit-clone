require 'capybara/rspec'
require 'webdrivers/chromedriver'

# Configure Webdrivers to use a specific chromedriver version that's compatible
# with Semaphore CI's environment
Webdrivers::Chromedriver.required_version = '114.0.5735.90' # Using a known stable version

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless
  end
end
