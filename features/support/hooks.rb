# frozen_string_literal: true

Before do |scenario|
  @browser = Helpers::Browser.create_browser(scenario)
  FixtureHelper.load_fixtures_for(scenario)
end

After do |scenario|
  binding.pry_if scenario.failed? && Nenv.debug?
  @browser.close
end
