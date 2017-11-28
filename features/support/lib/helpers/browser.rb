# frozen_string_literal: true

# Helper modules should all live in the helper namespace.
module Helpers
  # Helper module for creating browsers.
  module Browser
    # High level function for creating a browser. Uses env variables to determine what to do.
    #
    # @param scenario [Cucumber:Scenario]
    #
    def self.create_browser(scenario)
      send("create_#{Nenv.browser_type}_browser", scenario)
    end

    # Saves job status in Sauce Labs
    #
    # @param scenario [Cucumber:Scenario] The Cucumber scenario that just completed.
    #
    # @param browser [Watir::Browser]A Watir browser.  Used to pull session_id
    #
    def self.save_sauce_status(scenario, browser)
      job_fn = scenario.passed? ? 'pass_job' : 'fail_job'
      SauceWhisk::Jobs.send(job_fn, browser.driver.send(:bridge).session_id)
    end

    private_class_method

    # Creates a Sauce Labs browser.
    # Called by #create_browser when BROWSER_TYPE == :sauce
    #
    # @param scenario [Cucumber:Scenario] The scenario name and feature name will be used as the session name.
    #
    def self.create_sauce_browser(scenario)
      caps = sauce_caps(scenario)
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = Nenv.sauce_client_timeout

      Watir::Browser.new(:remote, url: Nenv.sauce_url, desired_capabilities: caps, http_client: client)
    end

    # Creates a local browser.
    # Called by #create_browser when BROWSER_TYPE == :local
    #
    # @param _scenario [Cucumber:Scenario] Not currently used
    #
    def self.create_local_browser(_scenario = nil)

      browser = Watir::Browser.new Nenv.browser_brand, Config.instance[Nenv.browser_brand]
      browser.window.move_to(Nenv.browser_x, Nenv.browser_y)
      #browser.window.resize_to(Nenv.browser_width, Nenv.browser_height)
      browser
    end

    # Creates a selenium hub browser.
    # Called by #create_browser when BROWSER_TYPE == :selenium_hub
    #
    # @param _scenario [Cucumber:Scenario] Not currently used
    #
    def self.create_selenium_hub_browser(_scenario = nil)
      caps = Selenium::WebDriver::Remote::Capabilities.send(Nenv.browser_brand)

      browser = Selenium::WebDriver.for(:remote, :url => Nenv.selenium_hub_url, :desired_capabilities => caps)
      # TODO: Browser sizing for selenium hub
      #browser.window.resize_to(Nenv.browser_width, Nenv.browser_height)
      browser
    end

    # Simple helper function for building a Sauce Labs caps file
    def self.sauce_caps(scenario)
      {
        version: Nenv.sauce_version,
        browserName: Nenv.browser_brand,
        platform: Nenv.sauce_platform,
        name: "#{scenario.feature.name} - #{scenario.name}",
        screenResolution: Nenv.browser_resolution
      }
    end
  end
end
