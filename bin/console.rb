# frozen_string_literal: true

require_relative '../features/support/env'

include PageObject::PageFactory
include DataMagic
FixtureHelper.load_fixture 'guidewire_test.yml'

@browser = Helpers::Browser.create_browser
page = visit(LoginPage)

binding.pry


puts 'Line for pry'