# frozen_string_literal: true
require 'nenv'
# Cucumber doesn't require files it loads them... multiple times
# We only want to do this once so we'll just see if Nenv responds to our method already
unless Nenv.respond_to? :test_env
  # These constants represent defaults for, or in some cases keys for, the Nenv methods below
  ENV_KEY = 'TEST_ENV' # What enviroment variable holds our runtime environment?
  DEFAULT_TEST_ENV = 'test' # What should the default TEST_ENV be?

  DEFAULT_CONFIG_PATH = './config' # Where should Helpers::Config load it's yml data

  DEFAULT_BROWSER_TYPE = :local # What should the default BROWSER_TYPE be?
  DEFAULT_BROWSER_BRAND = :chrome # What should the default BROWSER_BRAND be?
  DEFAULT_BROWSER_RESOLUTION = '1920x1080' # What should the default BROWSER_RESOLUTION be?
  DEFAULT_SAUCE_CLIENT_TIMEOUT = 180 # What should the default SAUCE_CLIENT_TIMEOUT be?


  DEFAULT_SELENIUM_HUB_HOST = 'localhost' # What should the default host be for Selenium hub
  DEFAULT_SELENIUM_HUB_PORT = 4444        # What should the default port be for Selenium hub

  DEFAULT_FIXTURE_ROOT = 'fixtures' # Default folder for fixture files

  # Stuff that tunes the framework
  Nenv.instance.create_method(:config_path) { |v| v.nil? ? DEFAULT_CONFIG_PATH : v.tr('\\', '/') }
  Nenv.instance.create_method(:fixture_root) { |v| v.nil? ? DEFAULT_FIXTURE_ROOT : v.tr('\\', '/') }

  # Stuff that changes based on the runtime environment for the app
  Nenv.instance.create_method(:test_env) { Nenv.send(ENV_KEY) || DEFAULT_TEST_ENV }
  Nenv.instance.create_method(:server_hostname) { |v| v.nil? ? Config.instance[:environments][Nenv.environment][:host] : v }

  # Stuff for creating browsers
  Nenv.instance.create_method(:browser_type) { |v| v.nil? ? DEFAULT_BROWSER_TYPE : v.to_sym }
  Nenv.instance.create_method(:browser_brand) { |v| v.nil? ? DEFAULT_BROWSER_BRAND : v.to_sym }
  Nenv.instance.create_method(:browser_resolution) { |v| v.nil? ? DEFAULT_BROWSER_RESOLUTION : v }
  Nenv.instance.create_method(:browser_width) { Nenv.browser_resolution.split('x').first.to_i }
  Nenv.instance.create_method(:browser_height) { Nenv.browser_resolution.split('x').last.to_i }
  Nenv.instance.create_method(:browser_x, &:to_i)
  Nenv.instance.create_method(:browser_y, &:to_i)

  # Sauce labs config
  Nenv.instance.create_method(:sauce_url) { |v| v.nil? ? Config.instance[:sauce_labs][:url] : v }
  Nenv.instance.create_method(:sauce_platform) { |v| v.to_s.tr('_', ' ') }
  Nenv.instance.create_method(:sauce_client_timeout) { |v| v.nil? ? DEFAULT_SAUCE_CLIENT_TIMEOUT : v.to_i }

  # Selenium hub config
  Nenv.instance.create_method(:selenium_hub_host) { |v| v.nil? ? DEFAULT_SELENIUM_HUB_HOST : v }
  Nenv.instance.create_method(:selenium_hub_port) { |v| v.nil? ? DEFAULT_SELENIUM_HUB_PORT : v.to_i }
  Nenv.instance.create_method(:selenium_hub_url) { |v| v.nil? ? "http://#{Nenv.selenium_hub_host}:#{Nenv.selenium_hub_port}/wd/hub" : v }
end
