# frozen_string_literal: true

require_relative 'sections/submission_sections'

# Abstraction for the submission tab.
#
# The real magic for this class is really in the WizardPanel it declares.
# However there's a couple additional toolbars available here.
class SubmissionTabPage < PolicyCenterPage
  page_section(:info_bar, SubmissionInfoBar, id: 'infoBar')
  page_section(:west_panel, SubmissionWestPanel, id: 'westPanel')

  page_section(:wizard_panel, WizardPanel, id: 'centerPanel')

  # rubocop:disable Lint/Debugger
  def pry
    binding.pry
    STDOUT.puts 'Line for pry' if Nenv.cuke_debug?
  end
  # rubocop:enable Lint/Debugger
end
