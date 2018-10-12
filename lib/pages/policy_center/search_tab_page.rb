
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

class SearchTabPage < PolicyCenterPage
  text_field(:policy_number, id: 'PolicySearch:PolicySearchScreen:DatabasePolicySearchPanelSet:PolicySearchDV:PolicyNumberCriterion-inputEl')
  link(:search, id: 'PolicySearch:PolicySearchScreen:DatabasePolicySearchPanelSet:PolicySearchDV:SearchAndResetInputSet:SearchLinksInputSet:Search')
  div(:ps_results_grid, id: 'PolicySearch:PolicySearchScreen:DatabasePolicySearchPanelSet:PolicySearch_ResultsLV-body')

  def wait_for_results
    Watir::Wait.until { ps_results_grid? && ps_results_grid_element.divs(class: 'x-grid-item-container').count.positive? }
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    retry
  end

  def policy_search_results
    ps_results_grid_element.divs(class: 'x-grid-item-container').map { |d| PolicySearchGridItem.new(d, false, self) }
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    retry
  end
end