
class MenuPanel < BasePage

end

class GearMenu < MenuPanel
  link(:log_out, text: /Log Out/)
end
class PolicyMenu < MenuPanel
  link(:new_submission, id: 'TabBar:PolicyTab:PolicyTab_NewSubmission-itemEl')
  text_field(:sub_no, id: 'TabBar:PolicyTab:PolicyTab_SubmissionNumberSearchItem-inputEl')
  div(:search_sub_no, id:'TabBar:PolicyTab:PolicyTab_SubmissionNumberSearchItem_Button')
  text_field(:policy_no, id: 'TabBar:PolicyTab:PolicyTab_PolicyRetrievalItem-inputEl')
  div(:search_policy_no, id:'TabBar:PolicyTab:PolicyTab_PolicyRetrievalItem_Button')
  div(:active_policy, id: 'TabBar:PolicyTab:0:PolicyMenuPolicy')
  link(:show_active_policy, id: 'TabBar:PolicyTab:0:PolicyMenuPolicy-itemEl')
end

class AccountMenu < MenuPanel
  link(:new_account, id: 'TabBar:AccountTab:AccountTab_NewAccount-itemEl')
end

class NorthPanel < BasePage
  image(:product_logo, class: 'product_logo')
  link(:gear_menu_button, id: ':TabLinkMenuButton')
  external_page_section(:gear_menu, GearMenu, :parent_browser, id: 'menu-1042-body')

  external_page_section(:policy_dd, PolicyMenu, :parent_browser, id: 'menu-1027-body')
  external_page_section(:account_dd, AccountMenu, :parent_browser, id: 'menu-1014-body')
  link(:show_policy_tab, id: 'TabBar:PolicyTab')
  link(:show_search_tab, id: 'TabBar:SearchTab')
  link(:show_account_tab, id: 'TabBar:AccountTab')

  def show_menu(which)
    send("#{which}_button")
    send(which)
  end

  def show_gear_menu
    show_menu :gear_menu
  end

  def click_right_side_of(element)
    e = element.is_a?(Symbol) ? self.send("#{element}_element") : element
    browser.driver.action.move_to( e.wd, e.wd.rect.width - 2, 2).click.perform
  end

  def show_policy_dd
    click_right_side_of(:show_policy_tab)
  end

  def show_search_dd
    click_right_side_of(:show_search_tab)
  end

  def show_account_dd
    click_right_side_of(:show_account_tab)
  end

  def new_policy
    show_policy_dd
    policy_dd.new_submission
  end

  def new_account
    show_account_dd
    account_dd.new_account
  end


  def search_for_policy_by_pol_no(pol_no)
    show_policy_dd
    policy_dd.policy_no = pol_no
    policy_dd.search_policy_no_element.click
  end

end