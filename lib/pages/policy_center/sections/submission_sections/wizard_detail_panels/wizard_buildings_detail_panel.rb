# frozen_string_literal: true
require_relative 'wizard_buildings_edit_detail_panel'

# Represents the building detail panel
class WizardBuildingsDetailPanel < WizardDetailPanel
  link_hooked(:add_building, hooks: WFA_HOOKS, text: 'Add Building')

  # Returns an instance of WizardBuildingsEditDetailPanel for editing the current building
  def building_editor
    WizardBuildingsEditDetailPanel.new(browser, false, parent_page)
  end

  # Adds one or more buildings from an array.
  #
  # Each element in the array should be a hash in the form that WizardBuildingsEditDetailPanel will accept
  def buildings=(data)
    return unless data
    data = [data] unless data.is_a?(Array)
    data.each do |building|
      add_building
      building_editor.populate(building)
    end
  end
end

# Represents the WRG version of the building detail panel
class WizardBuildingsandClassificationsDetailPanel < WizardBuildingsDetailPanel
end
