# frozen_string_literal: true

# Represents the detail panel for locations
# Partial mapping
class WizardLocationDetailPanel < WizardDetailPanel
  link_hooked(:add_all_existing, hooks: WFA_HOOKS, text: 'Add All Existing')

  # A helper to allow us to click the add all existing via our fixture
  def add_all_existing=(val)
    add_all_existing if val
  end
end
