# frozen_string_literal: true

class GoogleHomePage < BasePage
  page_url('https://www.google.com/')

  text_field(:search, id: 'lst-ib' , :hooks=>[{:before=>:value=, :call_chain=>[{:call=>:flash_element, :with=>[:element, 5]}, {:call=>:test_fn, :with=>[:page, :element]}]}])

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