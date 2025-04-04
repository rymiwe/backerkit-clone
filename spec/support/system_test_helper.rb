require 'capybara/rspec'
require 'webdrivers/chromedriver'

# Configure Webdrivers to use a specific chromedriver version if specified in environment
if ENV['WEBDRIVER_CHROME_VERSION']
  Webdrivers::Chromedriver.required_version = ENV['WEBDRIVER_CHROME_VERSION']
else
  # Default to a stable version known to work
  Webdrivers::Chromedriver.required_version = '114.0.5735.90'
end

# Add more debug info in CI environment
if ENV['CI'] || ENV['SEMAPHORE']
  puts "CI environment detected, configuring specialized system test settings"
  puts "Using Chrome driver version: #{Webdrivers::Chromedriver.required_version}"
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    # Configure Chrome options
    options = Selenium::WebDriver::Chrome::Options.new
    
    # Add stability options, especially for CI
    if ENV['HEADLESS'] == 'true' || ENV['CI'] || ENV['SEMAPHORE']
      options.add_argument('--headless')
      options.add_argument('--disable-gpu')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')
    end
    
    # Use consistent window size for tests
    options.add_argument('--window-size=1400,1400')
    
    # Use the configured Chrome with these options
    driven_by :selenium, using: :chrome, options: options

    # Skip if we have this flag set and we're in CI
    if ENV['SKIP_SYSTEM_TESTS_ON_FAIL'] == 'true' && (ENV['CI'] || ENV['SEMAPHORE'])
      # We're specifically running system tests in CI, but allow them to be skipped if needed
      begin
        page.driver.browser.version # Try accessing browser to verify it's working
      rescue => e
        skip "System test skipped due to browser setup issue: #{e.message}"
      end
    end
  end
end
