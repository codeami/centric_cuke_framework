require_relative 'bop_tabs'


class WizardLocationDetailPanel < WizardDetailPanel
  link_hooked(:add_all_existing, hooks: WFA_HOOKS, text: 'Add All Existing')

  def add_all_existing=(_val)
    add_all_existing
  end
end