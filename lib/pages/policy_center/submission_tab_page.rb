
require_relative 'sections/submission_sections'

class SubmissionTabPage < PolicyCenterPage
  page_section(:info_bar, SubmissionInfoBar, id: 'infoBar')
  page_section(:west_panel, SubmissionWestPanel, id: 'westPanel')

  page_section(:wizard_panel, WizardPanel, id: 'centerPanel-table')

end