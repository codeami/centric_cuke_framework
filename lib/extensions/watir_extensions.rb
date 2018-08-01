# frozen_string_literal: true

module Watir
  #
  # Base class for HTML elements.
  #

  class Element
    def scroll_and_click
      # This attempts to scroll item into view and then click it
      # if it still fails, likely due to the header in SFn, we scroll
      # the page down 100px and try again.

      self.wd.location_once_scrolled_into_view
      self.send(:click)
    rescue Selenium::WebDriver::Error::UnknownError => e
      puts 'Element not initially clickable'
      if e.message.include? 'Element is not clickable'
        self.driver.execute_script('window.scrollBy(0,-100);')
        self.send(:click)
      end
    end

    def relocate
      @element = locate
      self
    end
  end
end
