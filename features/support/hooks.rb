

Before do |scenario|
  @browser = Helpers::Browser.create_browser(scenario)
  #FixtureHelper.load_fixtures_for(scenario)
end

After do |scenario|
  if scenario.failed?

  end
  @browser.close if @browser
end