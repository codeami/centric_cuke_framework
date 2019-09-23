# frozen_string_literal: true

# Minimal model of the WRG hazard grade select page
class HazardGradeSelectPage < BasePage
  # Partial model of a a result for a hazard grade search
  class SearchResultRow < BasePage
    td(:gl_class, index: 1)
    link_hooked(:select, text: 'Select', hooks: WFA_HOOKS)
  end

  grid_view(:results_grid, SearchResultRow, id: 'ClassCodeBasedHazardCodeSearchPopup:GLAndBOPClassCodeSearchScreen:HazardCodeSearchResultsLV-body')

  # rubocop:disable Lint/Debugger
  def pry
    binding.pry
    STDOUT.puts 'Line for pry' if Nenv.debug?
  end
  # rubocop:enable Lint/Debugger

  # Given a gl class code find the item that matches it and select it
  def select_by_gl_class(code)
    results_grid.wait_for_items
    results_grid.items.find { |i| i.gl_class.start_with?(code.to_s) }.select
  end
end
