require_relative 'north_panel_link_menu'
class NorthPanel
  include PageObject
  img(:logo, class: 'product-logo')
  gw_dropdown(:link_menu,
              toggle: { identifier: { id: ':TabLinkMenuButton' }, state: { open: /menu-active/, closed: { not: /menu-active/ }} },
              menu:   { identifier: { xpath: "//div[descendant::a[@id='TabBar:HelpTabBarLink-itemEl'] and contains(@class, 'x-menu')]" }, class: NorthPanelLinkMenu,  parent_element: :parent_browser })

  def ensure_link_menu_open
    link_menu_toggle unless link_menu_toggle_open?
  end

  def ensure_link_menu_closed
    link_menu_toggle if link_menu_toggle_open?
  end
end