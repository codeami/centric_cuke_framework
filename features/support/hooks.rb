# frozen_string_literal: true

Before do |scenario|
  @browser = Helpers::Browser.create_browser(scenario)
  Helpers::Fixtures.load_fixtures_for(scenario)
end

After do |scenario|
  # rubocop:disable Lint/Debugger
  binding.pry if scenario.failed? && Nenv.debug?
  # rubocop:enable Lint/Debugger
  @browser.close
end
