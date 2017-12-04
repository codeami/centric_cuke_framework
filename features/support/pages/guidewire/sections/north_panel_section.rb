class NorthPanel
  include PageObject
  img(:logo, class: 'product-logo')
  #span_button(:link_menu_toggle, id: ':TabLinkMenuButton-btnInnerEl')
  link(:link_menu_toggle, id: ':TabLinkMenuButton')
  link(:ll_test, id: 'TabBar:LogoutTabBarLink-itemEl', root: :parent)
  link_hooked(:logout_link, id: 'TabBar:LogoutTabBarLink-itemEl', hooks: [{
                                                                            before: :text,
                                                                            call_chain: [
                                                                            {
                                                                              call: :ensure_link_menu_open
                                                                            }]
                                                                          },
                                                                          {
                                                                            before: :click,
                                                                            call_chain: [
                                                                            {
                                                                              call: :ensure_link_menu_open
                                                                            }]
                                                                          }])

  def link_menu_open?
    link_menu_toggle_element.when_present.element.class_name.include?('x-btn-menu-active')
  end

  def ensure_link_menu_open
    link_menu_toggle unless link_menu_open?
  end

  def ensure_link_menu_closed
    link_menu_toggle if link_menu_open?
  end

end