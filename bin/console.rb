# frozen_string_literal: true

require_relative '../features/support/env'
require 'ostruct'
include PageObject::PageFactory

# Trying out a DSL
def before(fn_name, call_chain)
  { before: fn_name, call_chain: call_chain}
end

def call(fn, opts={})
  { call: fn, with: opts.fetch(:with, []) }
end

def remap_withs(withs)
  withs.map! { |w| remap_with(w) }
end

def remap_with(with_var)
  return self if with_var == :self
  return self if with_var == :element
  return 'page' if with_var == :page
  with_var
end


test = { hooks: [before(:click,[call(:flash_page, with: 5)])] }

hooks = [before(:click,[call(:flash_page, with: [5])]),
         before(:value=,[call(:flash_page, with: [:element]), call(:fn_2, with: [:page])])]
binding.pry;2

#hooks.each { |hook| hook[:call_chain].each { |cc| cc[:with] = cc.fetch(:with, []).map { |c| remap_with(c) } } }

mock_scenario = OpenStruct.new({ name: 'Console Scenario', feature: OpenStruct.new({ name: 'Console Feature' }) })
@browser = Helpers::Browser.create_browser(mock_scenario)

page = visit(GoogleHomePage)
e = page.search_element

# This should flash the box 5 times
page.search = 'A Pry session is open'


binding.pry
puts 'Line for pry'