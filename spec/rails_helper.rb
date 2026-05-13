require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
require 'rspec/rails'
require 'shoulda/matchers'
require 'factory_bot_rails'
require 'capybara/rspec'
require 'selenium/webdriver'
require 'socket'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Capybara のドライバー登録
Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')

  # CI環境とローカル環境で接続先を切り替え
  selenium_url = ENV['CI'] ? 'http://localhost:4444/wd/hub' : 'http://chrome:4444/wd/hub'

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: selenium_url,
    options: options
  )
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.include FactoryBot::Syntax::Methods

  config.before(:each, type: :system) do
    if ENV['CI']
      Capybara.default_max_wait_time = 15
    else
      Capybara.default_max_wait_time = 5
    end
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    # ポート番号は自動割り当て（Capybara.server_portは自動で設定される）
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end

  config.infer_spec_type_from_file_location!
  config.include LoginMacros, type: :system
  config.filter_rails_from_backtrace!
end
