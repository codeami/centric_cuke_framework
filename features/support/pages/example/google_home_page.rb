# frozen_string_literal: true

class GoogleHomePage < BasePage
  page_url('https://www.google.com/')
  #text_field(:search, id: 'lst-ib' , hooks: [{ before: :value=, call: [:flash_search] }] )
  text_field(:search, id: 'lst-ib' , :hooks=>[{:before=>:click, :call_chain=>[{:call=>:flash_page, :with=>[5]}]},
                                              {:before=>:value=, :call_chain=>[{:call=>:test_fn, :with=>[:element, :page]}, {:call=>:flash_search, :with=>[5]}]}])

  def test_fn(e, p)

    binding.pry;2
    puts p
  end
  def flash_search(count)
    count.times do
      search_element.flash
      sleep 0.25
    end
  end

end