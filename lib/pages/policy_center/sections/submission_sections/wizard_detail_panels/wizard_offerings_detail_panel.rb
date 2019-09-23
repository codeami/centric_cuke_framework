# frozen_string_literal: true

# Models the offering detail panel
class WizardOfferingsDetailPanel < WizardDetailPanel
  gw_table_select_list(:offering_selection, id: 'SubmissionWizard:OfferingScreen:OfferingSelection-triggerWrap')
end
