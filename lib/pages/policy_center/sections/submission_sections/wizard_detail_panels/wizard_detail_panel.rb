
class WizardDetailPanel < BasePage
  gw_question_set(:questions, class: %w[x-container x-container-default x-table-layout-ct], index: -1)

  def populate(data)
    self.questions.set(data)
  end
end