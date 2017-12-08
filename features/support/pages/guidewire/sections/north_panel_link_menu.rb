class NorthPanelLinkMenu
  include PageObject

  # For things inside
  LM_HOOKS = CptHook.define_hooks do
    before(:text).call(:ensure_link_menu_open).using( :parent_page )
    before(:click).call(:ensure_link_menu_open).using( :parent_page )
    before(:exists?).call(:ensure_link_menu_open).using( :parent_page )
  end

  link_hooked(:logout_link, id: 'TabBar:LogoutTabBarLink-itemEl', hooks: LM_HOOKS )
end