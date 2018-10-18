
class WizardPolicyInfoDetailPanel < WizardDetailPanel
  #gw_question_set(:policy_info, class: %w[x-container x-container-default x-table-layout-ct], index: -4)
  gw_form_set(:policy_info, id: 'SubmissionWizard:LOBWizardStepGroup:SubmissionWizard_PolicyInfoScreen:SubmissionWizard_PolicyInfoDV_ref-table')
end