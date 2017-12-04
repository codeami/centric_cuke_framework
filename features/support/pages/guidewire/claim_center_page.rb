require_relative 'sections/north_panel_section'
require_relative 'sections/west_panel_section'

class ClaimCenterPage < BasePage
  page_url "#{Nenv.base_url}/ClaimCenter.do"
  text_field(:password, id: 'Login:LoginScreen:LoginDV:password-inputEl')

  page_section(:north_panel, NorthPanel, id: 'northPanel')
  page_section(:west_panel, WestPanel, id: 'westPanel')

  def need_login?
    self.password?
  end

end