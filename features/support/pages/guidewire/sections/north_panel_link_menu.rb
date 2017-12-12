# frozen_string_literal: true

# A section to contain the link menu that's dropped down from the link_menu_toggle in the north panel
class NorthPanelLinkMenu
  include PageObject

  other_hooks = define_hooks do
    before(:click).call(:ensure_link_menu_open).using(:parent_page)
  end

  # For things inside
  LM_HOOKS = define_hooks do
    before(:text).call(:ensure_link_menu_open).using(:parent_page)
    merge!(other_hooks)
  end

  link_hooked(:logout_link, id: 'TabBar:LogoutTabBarLink-itemEl', hooks: LM_HOOKS)
end
