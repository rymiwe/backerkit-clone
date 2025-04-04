require 'capybara/rspec'
require 'webdrivers/chromedriver'

# Configure Webdrivers to use a specific chromedriver version that's compatible
# with Semaphore CI's environment
Webdrivers::Chromedriver.required_version = '114.0.5735.90' # Using a known stable version

RSpec.configure do |config|
  config.before(:each, type: :system) do
    # Set Chrome options for a more stable CI environment
    options = Selenium::WebDriver::Chrome::Options.new
    
    # Add more stability options for CI
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--window-size=1400,1400')
    
    # Use the configured Chrome with these options
    driven_by :selenium, using: :chrome, options: options
  end
end
