# frozen_string_literal: true

# this doesn't really belong here it's not generic but this is a handy place to build it
require 'page-object/accessors'
module PageObject
  #
  # Contains the class level methods that are inserted into your page objects
  # when you include the PageObject module.  These methods will generate another
  # set of methods that provide access to the elements on the web pages.
  #
  module Accessors
    # rubocop:disable Metrics/AbcSize
    def gw_dropdown(name, opts)
      link("#{name}_toggle".to_sym, opts[:toggle][:identifier])
      css_state("#{name}_toggle".to_sym, opts[:toggle][:state])

      if opts[:menu][:parent_element]
        external_page_section(name, opts[:menu][:class], opts[:menu][:parent_element], opts[:menu][:identifier])
      else
        page_section(name, opts[:menu][:class], opts[:menu][:identifier])
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
