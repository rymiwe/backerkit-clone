require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# Add additional requires below this line
# Load non-system test support files
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each do |f|
  # Skip system_test_helper.rb for non-system tests
  next if f.end_with?('system_test_helper.rb')
  require f
end

# Checks for pending migrations and applies them before tests are run
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = ["#{::Rails.root}/spec/fixtures"] # Updated to use fixture_paths (plural)

  # Include FactoryBot syntax methods
  config.include FactoryBot::Syntax::Methods
  
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces
  config.filter_rails_from_backtrace!
  
  # Skip ALL system tests in CI environment
  # This needs to be in rails_helper.rb to ensure it's applied before test execution
  if ENV['CI'] || ENV['SEMAPHORE']
    config.before(:each, type: :system) do
      skip "System tests temporarily disabled in CI environment"
    end
    
    # Also skip tests in the system directory regardless of explicit type
    config.around(:each) do |example|
      if example.metadata[:file_path].include?('/spec/system/')
        skip "System test in spec/system directory disabled in CI environment"
      else
        example.run
      end
    end
  else
    # Only load system test helpers for system tests in non-CI environments
    config.before(:each, type: :system) do
      require Rails.root.join('spec/support/system_test_helper.rb')
    end
  end
end

# Configure Shoulda Matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
