
class SingleProductGridItem < BasePage
    link(:select_product, xpath: './/tr/td[1]/a')
    div(:product_name, xpath: './/tr/td[2]/div')
    div(:product_description, xpath: './/tr/td[3]/div')
    div(:product_status, xpath: './/tr/td[4]/div')
end

class MultiProductGridItem < BasePage
  gw_dropdown_cell(:num_to_create, xpath: './/tr/td[1]/div')
  div(:product_name, xpath: './/tr/td[2]/div')
  div(:product_description, xpath: './/tr/td[3]/div')
  div(:product_status, xpath: './/tr/td[4]/div')
end

class NewSubmissionTabPage < PolicyCenterPage
  revealing_text_field(:account_number, :account_name?, id: 'NewSubmission:NewSubmissionScreen:SelectAccountAndProducerDV:Account-inputEl')
  div(:account_name, id: 'NewSubmission:NewSubmissionScreen:SelectAccountAndProducerDV:AccountName-inputEl')
  revealing_text_field(:organization, :producer_code?, hooks: SEARCH_EDIT_HOOKS, id: 'NewSubmission:NewSubmissionScreen:SelectAccountAndProducerDV:ProducerSelectionInputSet:Producer-inputEl')
  text_field_hooked(:producer_code, hooks: SEARCH_EDIT_HOOKS, id: 'NewSubmission:NewSubmissionScreen:SelectAccountAndProducerDV:ProducerSelectionInputSet:ProducerCode-inputEl')
  text_field_hooked(:quote_type, hooks: SEARCH_EDIT_HOOKS, id: 'NewSubmission:NewSubmissionScreen:ProductSettingsDV:QuoteType-inputEl')
  text_field_hooked(:base_state, hooks: SEARCH_EDIT_HOOKS, id: 'NewSubmission:NewSubmissionScreen:ProductSettingsDV:DefaultBaseState-inputEl')
  text_field_hooked(:effective_date, hooks: SEARCH_EDIT_HOOKS, id: 'NewSubmission:NewSubmissionScreen:ProductSettingsDV:DefaultPPEffDate-inputEl')

  gw_radio_array(:single_or_multiple_radios, id: 'NewSubmission:NewSubmissionScreen:ProductSettingsDV:CreateSingle-bodyEl')

  grid_view(:single_product_grid, SingleProductGridItem, id: 'NewSubmission:NewSubmissionScreen:ProductOffersDV:ProductSelectionLV')
  grid_view(:multi_product_grid, MultiProductGridItem, id: 'NewSubmission:NewSubmissionScreen:ProductOffersDV:ProductSelectionLV')

  link(:make_submissions, id: 'NewSubmission:NewSubmissionScreen:ProductOffersDV:ProductSelectionLV_tb:MakeSubmissions')


  def product_grid
    make_submissions? ? multi_product_grid : single_product_grid
  end

  def single_or_multiple
    self.single_or_multiple_radios
  end

  def single_or_multiple=(value)
    self.single_or_multiple_radios = value
    is_multi = value.downcase == 'multiple'
    Watir::Wait.until { is_multi ? make_submissions? : !make_submissions? }
  end

end