require_relative 'north_panel_link_menu'
class NorthPanel
  include PageObject
  img(:logo, class: 'product-logo')
  link(:link_menu_toggle, id: ':TabLinkMenuButton')


  external_page_section(:link_menu, NorthPanelLinkMenu, :parent_browser, id: 'menu-1037-body')
  css_state(:link_menu_toggle, open: /menu-active/, closed: { not: /menu-active/ })

  def ensure_link_menu_open
    link_menu_toggle unless link_menu_toggle_open?
  end

  def ensure_link_menu_closed
    link_menu_toggle if link_menu_toggle_open?
  end

end