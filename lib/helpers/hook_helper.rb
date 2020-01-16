# frozen_string_literal: true

require 'uri'
module HookHelper
  def self.auth_url_for(url, creds)
    "https://#{URI.escape(creds['username'])}:#{URI.escape(creds['password'])}@#{url.gsub('https://', '')}"
  end

  # @return [Watir::Browser] a new browser based on tags in the scenario
  def self.create_browser(scenario)
    tags = scenario.send(scenario.respond_to?(:tags) ? :tags : :source_tags)
    tag_names = tags.map(&:name)

    # figure out local or remote first, if remote avoid local creation
    browser_type = ENV.fetch('BROWSER_TYPE', 'local').downcase.to_sym
    return create_remote_browser(scenario) if browser_type == :remote

    # if local, launch local broswer
    create_local_browser ENV.fetch('BROWSER', 'chrome').downcase.to_sym, !tag_names.include?('@no_headless')
  end

  # @return [Watir::Browser] a new remote browser based on tags in the scenario
  def self.create_remote_browser(scenario)
    caps = sauce_caps(scenario)
    url = 'http://Justjoehere:4bea1fca-917b-4970-b97f-3fe09d104f77@ondemand.saucelabs.com:80/wd/hub'.strip

    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 180

    Watir::Browser.new(:remote, url: url, desired_capabilities: caps, http_client: client)
  end

  # @return [Watir::Browser] a new local browser based on tags in the scenario
  def self.create_local_browser(browser_brand, allow_headless)
    browser_brand ||= :chrome
    if browser_brand == :chrome
      profile = Selenium::WebDriver::Chrome::Profile.new
      profile['credentials_enable_service'] = false
      profile['password_manager_enabled'] = false
      profile['autofill.enabled'] = false
      browser = Watir::Browser.new :chrome, profile: profile if !Nenv.headless? || !allow_headless
      browser = Watir::Browser.new :chrome, args: ['--window-size=1920,3000', '--disable-logging', '--log-level=3'], headless: true, profile: profile if Nenv.headless? && allow_headless
    else
      browser = Watir::Browser.new browser_brand
    end

    browser.window.move_to(0, 0)
    unless ENV['BROWSER_RESOLUTION'].nil?
      resolution = ENV['BROWSER_RESOLUTION'].downcase.split('x')
      browser.window.resize_to(resolution[0].to_i, resolution[1].to_i)
    end
    browser
  end

  # @return [Hash] A caps hash for sauce labs
  def self.sauce_caps(scenario)
    {
      version: ENV['SAUCE_VERSION'],
      browserName: ENV['BROWSER'],
      platform: ENV['SAUCE_PLATFORM'].to_s.tr('_', ' '),
      name: "#{scenario.feature.name} - #{scenario.name}",
      screenResolution: ENV['BROWSER_RESOLUTION']
    }
  end

  # Saves the results of a sauce labs session
  # @return [nil]
  def self.save_remote_results(scenario, browser)
    session_id = browser.driver.send(:bridge).session_id

    if scenario.passed?
      SauceWhisk::Jobs.pass_job session_id
    else
      SauceWhisk::Jobs.fail_job session_id
    end
  end
end
