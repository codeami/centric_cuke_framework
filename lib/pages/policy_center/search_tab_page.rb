# frozen_string_literal: true

# Abstraction for the search tab
class SearchTabPage < PolicyCenterPage

  # Abstraction for a row of items in the results grid of the search tab
  class PolicySearchGridItem < BasePage
    div(:policy_number, xpath: './/tr/td[3]/div')
    link(:open_policy, xpath: './/tr/td[3]//a')
    div(:primary_name, xpath: './/tr/td[4]/div')
    div(:account_number, xpath: './/tr/td[5]/div')
    link(:open_account, xpath: './/tr/td[5]/a')
    div(:product, xpath: './/tr/td[6]/div')
    div(:status, xpath: './/tr/td[7]/div')
    div(:effective_date, xpath: './/tr/td[8]/div')
    div(:expiration_date, xpath: './/tr/td[9]/div')
    div(:producer, xpath: './/tr/td[10]/div')
  end

  text_field(:policy_number, id: 'PolicySearch:PolicySearchScreen:DatabasePolicySearchPanelSet:PolicySearchDV:PolicyNumberCriterion-inputEl')
  link(:search, id: 'PolicySearch:PolicySearchScreen:DatabasePolicySearchPanelSet:PolicySearchDV:SearchAndResetInputSet:SearchLinksInputSet:Search')
  div(:ps_results_grid, id: 'PolicySearch:PolicySearchScreen:DatabasePolicySearchPanelSet:PolicySearch_ResultsLV-body')

  # Block until there are results in the search results.
  def wait_for_results
    Watir::Wait.until { ps_results_grid? && ps_results_grid_element.divs(class: 'x-grid-item-container').count.positive? }
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    attempts ||= 0
    attempts += 1
    binding.pry if Nenv.cuke_debug?
    retry unless attempts > 3

  end

  # Return the contents of the list as instances of PolicySearchGridItem
  def policy_search_results
    ps_results_grid_element.divs(class: 'x-grid-item-container').map { |d| PolicySearchGridItem.new(d, false, self) }
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    attempts ||= 0
    attempts += 1
    binding.pry if Nenv.cuke_debug?
    retry unless attempts > 3
  end
end
