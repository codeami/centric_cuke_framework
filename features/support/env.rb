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

# Set up the world
World(PageObject::PageFactory)
World(DataMagic)


