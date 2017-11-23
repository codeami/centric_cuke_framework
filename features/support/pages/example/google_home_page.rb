# frozen_string_literal: true

class GoogleHomePage < BasePage
  page_url('https://www.google.com/')
  text_field(:search, id: 'lst-ib' , hooks: [{ before: :value=, call: [:flash_search] }] )

  def flash_search
    5.times do
      search_element.flash
      sleep 0.25
    end
  end

end