require_relative 'bop_tabs'


class WizardBuildingsEditDetailPanel < WizardDetailPanel
  link_hooked(:update_building, hooks: WFA_HOOKS, text: 'Update Building')
  gw_form_set(:location_details, id: 'BOPBuildingPopup:BOPSingleBuildingDetailScreen:BOPBuilding_DetailsCardTab:panelId-table')

  def populate(data)
    location_details.set(data)
    update_building
  end
end