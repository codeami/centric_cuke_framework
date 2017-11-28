# frozen_string_literal: true

require_relative '../features/support/env'

include PageObject::PageFactory

#MagicPath.create_path :fixture_path, { pattern: 'fixtures' }
#MagicPath.create_path :fixture_file_base, { pattern: ':fixture_path/:filename:ext' }
#MagicPath.create_path :fixture_file_env, { pattern: ':fixture_path/:filename.:test_env:ext' }

fn = 'fixtures/foo/bar.yml'

s = MagicPath.fixture_file_env.resolve( { filename: File.basename(fn, '.yml'), ext: '.yml' } )

pat = /(?:\:)(\w(?:\w+|\d+))/
str = '/foo/:bar/fred/:bar2/:file.:ext'

FixtureHelper.load_fixture 'chrome.yml'

binding.pry
@browser = Helpers::Browser.create_browser


puts 'Line for pry'