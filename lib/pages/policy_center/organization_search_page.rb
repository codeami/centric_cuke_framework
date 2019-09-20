class OrganizationSearchPage < BasePage
  class SearchResultRow < BasePage
    td(:organization, index: 1)
    link_hooked(:select, text: 'Select', hooks: WFA_HOOKS)
  end

  text_field(:organization_code, id: 'OrganizationSearchPopup:OrganizationSearchPopupScreen:OrganizationSearchDV:Code-inputEl')
  link_hooked(:search, id: 'OrganizationSearchPopup:OrganizationSearchPopupScreen:OrganizationSearchDV:SearchAndResetInputSet:SearchLinksInputSet:Search', hooks: WFA_HOOKS)
  grid_view(:results_grid, SearchResultRow, id: 'OrganizationSearchPopup:OrganizationSearchPopupScreen:OrganizationSearchResultsLV-body')

  def pry
    binding.pry
    STDOUT.puts
  end

  def select_organization_by_code(code)
    self.organization_code = code.to_s
    search
    results_grid.wait_for_items
    results_grid.items.first.select
  end

end