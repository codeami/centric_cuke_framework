require_relative 'bop_tabs'

class ClassificationsEditor < BaseSection
  text_field_hooked(:classification_sq_ft, id: 'SubmissionWizard:LOBWizardStepGroup:LineWizardStepSet:BP7BuildingScreen:BP7BuildingPanelSet:BuildingsEdit_DP:BP7BuildingDetailCV:BP7BuildingCoveragesPanelSet:ClassificationsListDetail:Area-inputEl', hooks: WFA_HOOKS)
end


class WizardBuildingsEditDetailPanel < WizardDetailPanel
  link_hooked(:add_building, text: 'Add Building', hooks: WFA_HOOKS)
  link_hooked(:add_classification, text: 'Add Classification', hooks: WFA_HOOKS)
  text_field_hooked(:year_built, id: 'SubmissionWizard:LOBWizardStepGroup:LineWizardStepSet:BP7BuildingScreen:BP7BuildingPanelSet:BuildingsEdit_DP:BP7BuildingDetailCV:BP7BuildingCoveragesPanelSet:YearBuilt-inputEl', hooks: WFA_HOOKS)
  gw_table_select_list(:construction_type_select, id: 'SubmissionWizard:LOBWizardStepGroup:LineWizardStepSet:BP7BuildingScreen:BP7BuildingPanelSet:BuildingsEdit_DP:BP7BuildingDetailCV:BP7BuildingCoveragesPanelSet:ConstructionType-triggerWrap', hooks: WFA_HOOKS)
  gw_table_select_list(:percentage_owner_occupied, id: 'SubmissionWizard:LOBWizardStepGroup:LineWizardStepSet:BP7BuildingScreen:BP7BuildingPanelSet:BuildingsEdit_DP:BP7BuildingDetailCV:BP7BuildingCoveragesPanelSet:PercentOwnerOccupied-triggerWrap', hooks: WFA_HOOKS)
  gw_table_check(:building_coverages_enabled, id: 'SubmissionWizard:LOBWizardStepGroup:LineWizardStepSet:BP7BuildingScreen:BP7BuildingPanelSet:BuildingsEdit_DP:BP7BuildingDetailCV:BP7BuildingCoveragesPanelSet:MandatoryCoverages:BP7CoveragesDV:0:BP7CoverageInputSet:CovPatternInputGroup-legendChk', hooks: WFA_HOOKS)
  text_field_hooked(:building_limit, id: 'SubmissionWizard:LOBWizardStepGroup:LineWizardStepSet:BP7BuildingScreen:BP7BuildingPanelSet:BuildingsEdit_DP:BP7BuildingDetailCV:BP7BuildingCoveragesPanelSet:MandatoryCoverages:BP7CoveragesDV:0:BP7CoverageInputSet:CovPatternInputGroup:0:BP7CovTermInputSet:DirectTermInput-inputEl', hooks: WFA_HOOKS)

  div(:classification_editor_div, id: 'SubmissionWizard:LOBWizardStepGroup:LineWizardStepSet:BP7BuildingScreen:BP7BuildingPanelSet:BuildingsEdit_DP:BP7BuildingDetailCV:BP7BuildingCoveragesPanelSet:ClassificationsListDetail_ref')

  def populate(data)
    wait_for_ajax
    populate_page_with(data)
  end

  def construction_type=(val)
    sleep 1
    self.construction_type_select = val
  end

  def classifications=(val)
    div = classification_editor_div_element
    val.each do |c|
      add_classification
      Watir::Wait.until { classification_editor_div? }
      ClassificationsEditor.new(div.element, false, self).populate_page_with(c)
    end
  end

end