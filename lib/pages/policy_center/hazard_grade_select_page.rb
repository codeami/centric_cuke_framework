class HazardGradeSelectPage < BasePage

  class SearchResultRow < BasePage
    td(:gl_class, index: 1)
    link_hooked(:select, text: 'Select', hooks: WFA_HOOKS)
  end

  grid_view(:results_grid, SearchResultRow, id: 'ClassCodeBasedHazardCodeSearchPopup:GLAndBOPClassCodeSearchScreen:HazardCodeSearchResultsLV-body')

  def pry
    binding.pry
    STDOUT.puts
  end

  def select_by_gl_class(code)
    results_grid.wait_for_items
    results_grid.items.find { |i| i.gl_class.start_with?(code)}.select
  end

end