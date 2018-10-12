
require_relative 'sections/north_panel'

class PolicyCenterPage < BasePage

  page_section(:north_panel, NorthPanel, id: 'northPanel')

  def logout()

  end
end