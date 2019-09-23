class WizardPaymentDetailPanel < WizardDetailPanel
  gw_table_select_list(:where_should_payment_be_mailed, id: 'SubmissionWizard:SubmissionWizard_PaymentScreen:BindSummaryDV:PolicyBindPrintDelivery-triggerWrap', hooks: WFA_HOOKS)
  text_field_hooked(:downpayment_amount_edit, id: 'SubmissionWizard:SubmissionWizard_PaymentScreen:BillingAdjustmentsDV:PlanInputSet:DownPaymenthMethodInputSet:DownPaymentMethodInputSet:Amount-inputEl', hooks: WFA_HOOKS)
  gw_table_select_list(:downpayment_method, id: 'SubmissionWizard:SubmissionWizard_PaymentScreen:BillingAdjustmentsDV:PlanInputSet:PaymentMethodInput-triggerWrap', hooks: WFA_HOOKS)
  link_hooked(:issue_policy_button, id: 'SubmissionWizard:SubmissionWizard_PaymentScreen:JobWizardToolbarButtonSet:IssuePolicy', hooks: WFA_HOOKS)

  span(:ok_button, xpath: "//span[text() = 'OK']")

  def downpayment_amount=(val)
    downpayment_amount_edit_element.focus
    self.downpayment_amount_edit = val
    self.downpayment_amount_edit = val
  end

  def downpayment_amount
    downpayment_amount_edit
  end

  def issue_policy
    issue_policy_button
    ok_button_element.click
    wait_for_ajax
  end

  def issue_policy=(val)
    issue_policy if val
  end
end