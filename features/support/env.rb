# frozen_string_literal: true
$LOAD_PATH.unshift( "#{File.dirname(__FILE__)}/../..") # Add the project root to the lib path so we can easily include lib files.
require 'rubygems'
require 'bundler/setup'
require 'nenv'
require 'rspec/expectations'
require 'facets'
require 'data_magic'
require 'watir'
require 'page-object'
require 'sauce-whisk'
require 'pry'


require 'lib/nenv'
require 'lib/extensions'
require 'lib/helpers'
require 'lib/matchers'
require_relative 'pages'

# Set up the world
if defined?(World)
  World(PageObject::PageFactory)
  World(DataMagic)
end