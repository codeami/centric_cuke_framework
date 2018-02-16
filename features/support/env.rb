# frozen_string_literal: true

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../..") # Add the project root to the lib path so we can easily include lib files.
require 'rubygems'
require 'bundler/setup'
require 'nenv'
require 'cucumber'
require 'rspec/expectations'
require 'facets'
require 'data_magic'
require 'watir'
require 'page-object'
require 'c2po'
require 'sauce-whisk'
require 'magic_path'
require 'pry'

require 'lib/nenv_vars'
require_relative 'paths'
require 'lib/extensions'
require 'lib/helpers'
require 'lib/matchers'
require 'lib/parameter_types'
require 'lib/pages'

# Set up the world
begin
  World(PageObject::PageFactory)
  World(DataMagic)
# rubocop:disable Lint/RescueException
rescue Exception
  puts 'Warning failed to initialize the world.  This is only OK if in the console!'
end
PageObject::JavascriptFrameworkFacade.framework = :angularjs
# rubocop:enable Lint/RescueException
