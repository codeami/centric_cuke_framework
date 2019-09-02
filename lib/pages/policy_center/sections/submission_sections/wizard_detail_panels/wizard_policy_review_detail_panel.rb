class WizardPolicyReviewDetailPanel < WizardDetailPanel
  link(:quote_policy, text: 'Quote')

  def populate(data)
    quote_policy
  end
end