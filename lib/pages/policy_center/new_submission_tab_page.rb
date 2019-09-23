# frozen_string_literal: true

# Model for the new submission tab in Guidewire 9
class NewSubmissionTabPage < PolicyCenterPage

  # A grid item that contains multiples to create
  class MultiProductGridItem < BasePage
    gw_dropdown_cell(:num_to_create, xpath: './/tr/td[1]/div')
    div(:product_name, xpath: './/tr/td[2]/div')
    div(:product_description, xpath: './/tr/td[3]/div')
    div(:product_status, xpath: './/tr/td[4]/div')
  end

  # A grid item that is a highlander
  class SingleProductGridItem < BasePage
    link(:select_product, xpath: './/tr/td[1]//a')
    div(:product_name, xpath: './/tr/td[2]/div')
    div(:product_description, xpath: './/tr/td[3]/div')
    div(:product_status, xpath: './/tr/td[4]/div')
  end

  revealing_text_field(:account_number, :account_name?, id: 'NewSubmission:NewSubmissionScreen:SelectAccountAndProducerDV:Account-inputEl')
  div(:account_name, id: 'NewSubmission:NewSubmissionScreen:SelectAccountAndProducerDV:AccountName-inputEl')
  revealing_text_field(:organization, :producer_code?, hooks: SEARCH_EDIT_HOOKS, id: 'NewSubmission:NewSubmissionScreen:SelectAccountAndProducerDV:ProducerSelectionInputSet:Producer-inputEl')
  gw_select_list(:producer_code, id: 'NewSubmission:NewSubmissionScreen:SelectAccountAndProducerDV:ProducerSelectionInputSet:ProducerCode-bodyEl')
  gw_select_list(:quote_type, id: 'NewSubmission:NewSubmissionScreen:ProductSettingsDV:QuoteType-bodyEl')
  gw_select_list(:base_state, id: 'NewSubmission:NewSubmissionScreen:ProductSettingsDV:DefaultBaseState-bodyEl')
  text_field_hooked(:effective_date, hooks: SEARCH_EDIT_HOOKS, id: 'NewSubmission:NewSubmissionScreen:ProductSettingsDV:DefaultPPEffDate-inputEl')

  gw_radio_array(:single_or_multiple_radios, id: 'NewSubmission:NewSubmissionScreen:ProductSettingsDV:CreateSingle-bodyEl')

  grid_view(:single_product_grid, SingleProductGridItem, id: 'NewSubmission:NewSubmissionScreen:ProductOffersDV:ProductSelectionLV')
  grid_view(:multi_product_grid, MultiProductGridItem, id: 'NewSubmission:NewSubmissionScreen:ProductOffersDV:ProductSelectionLV')

  link(:make_submissions, id: 'NewSubmission:NewSubmissionScreen:ProductOffersDV:ProductSelectionLV_tb:MakeSubmissions')

  # Note this isn't on the page, however it's handy to declare it here so we can wait on it.
  # when we select a product from the grid.
  span(:submission_wizard_title, id: 'SubmissionWizard:OfferingScreen:ttlBar')

  # Returns the appropriate grid (single vs multi product)
  def product_grid
    make_submissions? ? multi_product_grid : single_product_grid
  end

  # Returns which mode we're in
  def single_or_multiple
    single_or_multiple_radios
  end

  # Sets the single/multiple mode
  def single_or_multiple=(value)
    self.single_or_multiple_radios = value
    is_multi = value.downcase == 'multiple'
    Watir::Wait.until { is_multi ? make_submissions? : !make_submissions? }
  end

  # Selects a single product via name.  This can be a string or regex.
  def single_product_name=(str_or_regex)
    product = product_grid.find_item(:product_name, str_or_regex)
    raise "Could not find a product matching #{str_or_regex}" unless product

    product.select_product
    Watir::Wait.until { submission_wizard_title? }
  end
end
