
require_relative 'sections/submission_sections'

class SubmissionTabPage < PolicyCenterPage
  page_section(:info_bar, SubmissionInfoBar, id: 'infoBar')
  page_section(:west_panel, SubmissionWestPanel, id: 'westPanel')

  gw_question_set(:bop_offering_questions, id: 'SubmissionWizard:OfferingScreen:OfferingQuestionSetsDV:QuestionSetsDV')
end