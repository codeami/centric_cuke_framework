# frozen_string_literal: true

# Note: This class is not safe for use at WRG currently
class WizardBusinessownersLineDetailPanel < WizardDetailPanel
  gw_tab_set(:coverage_info_tabs, id: 'SubmissionWizard:LOBWizardStepGroup:LineWizardStepSet:BOPScreen:0')
  gw_form_set(:small_business_type, id: 'SubmissionWizard:LOBWizardStepGroup:LineWizardStepSet:BOPScreen:BOPLinePanelSet:BOPLineDV-table')
  gw_form_set(:property_coverages, id: 'SubmissionWizard:LOBWizardStepGroup:LineWizardStepSet:BOPScreen:BOPLinePanelSet:BOPLinePropertyDV_ref-table')
  gw_form_set(:other_included_coverages, id: 'SubmissionWizard:LOBWizardStepGroup:LineWizardStepSet:BOPScreen:BOPLinePanelSet:BOPLineOtherIncludedDV_ref-table')
  gw_form_set(:liability_coverages, id: 'SubmissionWizard:LOBWizardStepGroup:LineWizardStepSet:BOPScreen:BOPLinePanelSet:BOPLiabilityDV_ref-table')

  def populate(data)
    small_business_type.set(data[:small_business_type.to_s])
    property_coverages.set(data[:property_coverages.to_s])
    liability_coverages.set(data[:liability_coverages.to_s])
    other_included_coverages.set(data[:other_included_coverages.to_s])
  end
end
