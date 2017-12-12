# frozen_string_literal: true

# A section to hold the west panel of the main page
class WestPanel
  include PageObject
  span_button(:actions_menu_button, id: 'Desktop:DesktopMenuActions-btnWrap')
end
