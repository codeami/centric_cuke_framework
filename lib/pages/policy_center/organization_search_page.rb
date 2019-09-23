# frozen_string_literal: true

# Model of the organization search page.  Includes a model for the search results.
class OrganizationSearchPage < BasePage

  # Model of a row of results.
  class SearchResultRow < BasePage
    td(:organization, index: 1)
    link_hooked(:select, text: 'Select', hooks: WFA_HOOKS)
  end

  text_field(:organization_code, id: 'OrganizationSearchPopup:OrganizationSearchPopupScreen:OrganizationSearchDV:Code-inputEl')
  link_hooked(:search, id: 'OrganizationSearchPopup:OrganizationSearchPopupScreen:OrganizationSearchDV:SearchAndResetInputSet:SearchLinksInputSet:Search', hooks: WFA_HOOKS)
  grid_view(:results_grid, SearchResultRow, id: 'OrganizationSearchPopup:OrganizationSearchPopupScreen:OrganizationSearchResultsLV-body')

  # rubocop:disable Lint/Debugger
  def pry
    binding.pry
    STDOUT.puts 'Line for pry' if Nenv.debug?
  end
  # rubocop:enable Lint/Debugger

  # Given an organization code navigate the steps to search for and select that code.
  def select_organization_by_code(code)
    self.organization_code = code.to_s
    search
    results_grid.wait_for_items
    results_grid.items.first.select
  end
end
