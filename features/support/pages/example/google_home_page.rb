# frozen_string_literal: true

# A sample page that automates google
class GoogleHomePage < BasePage
  page_url('https://www.google.com/')

  def test_fn(page, element)
    puts "Page: #{page}\nElement: #{element}"
  end

  def flash_element(element, count)
    count.times do
      element.flash
      sleep 0.25
    end
  end
end
