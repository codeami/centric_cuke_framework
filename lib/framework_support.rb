# frozen_string_literal: true

# This is the main require file for the framework
#
#
require 'nenv'
require 'cucumber'
require 'rspec/expectations'
require 'facets/string'
require 'data_magic'
require 'page-object'
require 'watir'
require 'sauce-whisk'
require 'magic_path'
require 'pry'

require_relative 'extensions'
require_relative 'element_hooks'
require_relative 'helpers'
require_relative 'pages'
require_relative 'routes'
require_relative 'parameter_types'
