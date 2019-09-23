# frozen_string_literal: true

# Model of the WRG class code search page and it's result row
class ClassCodeSearchPage < BasePage

  # Model of the result of a class code search
  class SearchResultRow < BasePage
    td(:class_code, index: 1)
    link_hooked(:select, text: 'Select', hooks: WFA_HOOKS)
  end

  text_field(:class_code, id: 'ClassCodeBasedHazardCodeSearchPopup:GLAndBOPClassCodeSearchScreen:BP7ClassCodeSearchPanel:BP7ClassCodeSearchDV:Code-inputEl')
  link_hooked(:search, id: 'ClassCodeBasedHazardCodeSearchPopup:GLAndBOPClassCodeSearchScreen:BP7ClassCodeSearchPanel:BP7ClassCodeSearchDV:SearchAndResetInputSet:SearchLinksInputSet:Search', hooks: WFA_HOOKS)
  grid_view(:results_grid, SearchResultRow, id: 'ClassCodeBasedHazardCodeSearchPopup:GLAndBOPClassCodeSearchScreen:BP7ClassCodeSearchPanel:ClassCodeSearchResultsLV-body')

  # rubocop:disable Lint/Debugger
  def pry
    binding.pry
    STDOUT.puts 'Line for pry' if Nenv.debug?
  end
  # rubocop:enable Lint/Debugger

  # Given a class code, manipulate the UI to select it
  def select_by_code(code)
    self.class_code = code.to_s
    search
    results_grid.wait_for_items
    results_grid.items.first.select
  end
end
