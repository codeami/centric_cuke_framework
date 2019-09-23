# frozen_string_literal: true

# Represents the payment details panel
class WizardPaymentDetailPanel < WizardDetailPanel
  gw_table_select_list(:where_should_payment_be_mailed, id: 'SubmissionWizard:SubmissionWizard_PaymentScreen:BindSummaryDV:PolicyBindPrintDelivery-triggerWrap', hooks: WFA_HOOKS)
  text_field_hooked(:downpayment_amount_edit, id: 'SubmissionWizard:SubmissionWizard_PaymentScreen:BillingAdjustmentsDV:PlanInputSet:DownPaymenthMethodInputSet:DownPaymentMethodInputSet:Amount-inputEl', hooks: WFA_HOOKS)
  gw_table_select_list(:downpayment_method, id: 'SubmissionWizard:SubmissionWizard_PaymentScreen:BillingAdjustmentsDV:PlanInputSet:PaymentMethodInput-triggerWrap', hooks: WFA_HOOKS)
  link_hooked(:issue_policy_button, id: 'SubmissionWizard:SubmissionWizard_PaymentScreen:JobWizardToolbarButtonSet:IssuePolicy', hooks: WFA_HOOKS)

  span(:ok_button, xpath: "//span[text() = 'OK']")

  # Special case handling for the downpayment amount.It needs set to $0 twice for it to stick at WRG
  def downpayment_amount=(val)
    downpayment_amount_edit_element.focus
    self.downpayment_amount_edit = val
    self.downpayment_amount_edit = val
  end

  # Provide an inspector for the downpayment amount since we overrode it there.
  def downpayment_amount
    downpayment_amount_edit
  end

  # Clicks the issue policy button and answers yes to the following prompt
  def issue_policy
    issue_policy_button
    ok_button_element.click
    wait_for_ajax
  end

  # Helper method to allow us to issue a policy by setting a value to true in our fixture
  def issue_policy=(val)
    issue_policy if val
  end
end
