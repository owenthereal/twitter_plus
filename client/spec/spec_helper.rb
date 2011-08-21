# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.before :all do
    DRb.start_service
    @remote_base = DRbObject.new nil, "druby://localhost:8000"
  end

  config.before :each do
    @remote_base.connection.increment_open_transactions
    @remote_base.connection.transaction_joinable = false
    @remote_base.connection.begin_db_transaction
  end

  config.after :each do
    @remote_base.connection.rollback_db_transaction
    @remote_base.connection.decrement_open_transactions
    @remote_base.clear_active_connections!
  end
end
