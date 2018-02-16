class LoginPage < BasePage
  page_url Nenv.sfn_url
  text_field(:search_field, css: '.search-input')
  button(:search_button, css: '.btn-search')
  radio_button(:all_radio, css: "label[for='result-type-all']")
  radio_button(:substance_radio, css: "label[for='result-type-substance']")
  radio_button(:reaction_radio, css: "label[for='result-type-reaction']")
  radio_button(:reference_radio, css: "label[for='result-type-reference']")
  radio_button(:supplier_radio, css: "label[for='result-type-commercial']")
  radio_button(:editor_button, css: '.draw-search-container .btn-draw')


  def search(query, search_type)
    select_search_type(search_type)
    self.search_field = query
    search_button
    binding.pry;2
    puts 'wee'
  end

  def select_search_type(search_type)
    send("set_#{search_type}")
  end
end