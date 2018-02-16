# frozen_string_literal: true

# Any helper which should be included by default should be required here.
# This file is loaded in env.rb immediately after the extensions are.
require_relative 'helpers/browser'
require_relative 'helpers/fixtures'
require_relative 'helpers/page_navigation'