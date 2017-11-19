# frozen_string_literal: true

require_relative '../features/support/env'
require 'ostruct'

mock_scenario = OpenStruct.new({ name: 'Console Scenario', feature: OpenStruct.new({ name: 'Console Feature' }) })

binding.pry

browser = Helpers::Browser.create_browser(mock_scenario)