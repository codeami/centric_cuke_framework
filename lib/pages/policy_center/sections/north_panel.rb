# frozen_string_literal: true

# A base class for menu panels
class MenuPanel < BasePage
end

# Abstracts the gear menu
class GearMenu < MenuPanel
  link(:log_out, text: /Log Out/)
end

# Abstracts the policy menu
class PolicyMenu < MenuPanel
  link(:new_submission, id: 'TabBar:PolicyTab:PolicyTab_NewSubmission-itemEl')
  text_field(:sub_no, id: 'TabBar:PolicyTab:PolicyTab_SubmissionNumberSearchItem-inputEl')
  div(:search_sub_no, id: 'TabBar:PolicyTab:PolicyTab_SubmissionNumberSearchItem_Button')
  text_field(:policy_no, id: 'TabBar:PolicyTab:PolicyTab_PolicyRetrievalItem-inputEl')
  div(:search_policy_no, id: 'TabBar:PolicyTab:PolicyTab_PolicyRetrievalItem_Button')
  div(:active_policy, id: 'TabBar:PolicyTab:0:PolicyMenuPolicy')
  link(:show_active_policy, id: 'TabBar:PolicyTab:0:PolicyMenuPolicy-itemEl')
end

# Abstracts the account menu
class AccountMenu < MenuPanel
  link(:new_account, id: 'TabBar:AccountTab:AccountTab_NewAccount-itemEl')
end

# Abstracts the panel at the top of the page containing menus
class NorthPanel < BasePage
  image(:product_logo, class: 'product_logo')
  link(:gear_menu_button, id: ':TabLinkMenuButton')
  external_page_section(:gear_menu, GearMenu, :parent_browser, id: 'menu-1042-body')

  external_page_section(:policy_dd, PolicyMenu, :parent_browser, id: 'menu-1027-body')
  external_page_section(:account_dd, AccountMenu, :parent_browser, id: 'menu-1014-body')
  link(:show_policy_tab, id: 'TabBar:PolicyTab')
  link(:show_search_tab, id: 'TabBar:SearchTab')
  link(:show_account_tab, id: 'TabBar:AccountTab')

  # Show a menu by name
  def show_menu(which)
    send("#{which}_button")
    send(which)
  end

  # Show the gear menu
  def show_gear_menu
    show_menu :gear_menu
  end

  # Helper to click menus at the right spot
  def click_right_side_of(element)
    e = element.is_a?(Symbol) ? send("#{element}_element") : element
    browser.driver.action.move_to(e.wd, e.wd.rect.width - 2, 2).click.perform
  end

  # Show the policy menu drop down
  def show_policy_dd
    click_right_side_of(:show_policy_tab)
  end

  # Show the search menu drop down
  def show_search_dd
    click_right_side_of(:show_search_tab)
  end

  # Show the account menu drop down
  def show_account_dd
    click_right_side_of(:show_account_tab)
  end

  # Navigate the menus to start a new policy
  def new_policy
    show_policy_dd
    policy_dd.new_submission
  end

  # Navigate the menus to start a new account
  def new_account
    show_account_dd
    account_dd.new_account
  end

  # Search for a policy by policy number
  def search_for_policy_by_pol_no(pol_no)
    show_policy_dd
    policy_dd.policy_no = pol_no
    policy_dd.search_policy_no_element.click
  end
end
