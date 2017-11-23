# frozen_string_literal: true

require_relative '../features/support/env'
require 'ostruct'
include PageObject::PageFactory

mock_scenario = OpenStruct.new({ name: 'Console Scenario', feature: OpenStruct.new({ name: 'Console Feature' }) })
@browser = Helpers::Browser.create_browser(mock_scenario)


visit(GoogleHomePage) do |page|
  # This should trigger the hooks but doesn't
  page.search = 'A Pry session is open'

  # This does work
  page.search_element.set 'A Pry session is open'
end
binding.pry
puts 'Line for pry'