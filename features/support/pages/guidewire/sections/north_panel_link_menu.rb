class NorthPanelLinkMenu
  include PageObject
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

end