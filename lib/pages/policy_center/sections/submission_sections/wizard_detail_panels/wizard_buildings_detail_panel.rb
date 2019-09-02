require_relative 'bop_tabs'
require_relative 'wizard_buildings_edit_detail_panel'

class WizardBuildingsDetailPanel < WizardDetailPanel
  link_hooked(:add_building, hooks: WFA_HOOKS, text: 'Add')

  def building_editor
    WizardBuildingsEditDetailPanel.new(browser, false, parent_page)
  end

  def buildings=(data)
    return unless data
    data.each do |building|
      add_building
      building_editor.populate(building)
    end
  end
end