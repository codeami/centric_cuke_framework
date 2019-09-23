# frozen_string_literal: true

require_relative 'sections/north_panel'

# Base class for all policy center pages.  Declares the north panel common to them all.
class PolicyCenterPage < BasePage
  page_section(:north_panel, NorthPanel, id: 'northPanel')

  def logout; end
end
