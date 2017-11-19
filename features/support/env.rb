# frozen_string_literal: true

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

require_relative 'lib/nenv'
require_relative 'lib/helpers'
require_relative 'lib/matchers'

# Set up the world
if defined?(World)
  World(PageObject::PageFactory)
  World(DataMagic)
end