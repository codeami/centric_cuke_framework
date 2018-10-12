
class SubmissionInfoBar < BasePage
  span(:job_label, id: 'SubmissionWizard:JobWizardInfoBar:JobLabel-btnWrap')
  span(:lob, id: 'SubmissionWizard:JobWizardInfoBar:LOBLabel-btnWrap')
  span(:eff_date_label, id: 'SubmissionWizard:JobWizardInfoBar:EffectiveDate-btnWrap')
  span(:account_name, id: 'SubmissionWizard:JobWizardInfoBar:AccountName-btnWrap')
  span(:account_no_label, id: 'SubmissionWizard:JobWizardInfoBar:AccountNumber-btnWrap')
  link( :open_account, id: 'SubmissionWizard:JobWizardInfoBar:AccountNumber')

  def account_no
    eff_date_label.gsub('Account #', '')
  end

  def eff_date
    Chronic.parse(eff_date)
  end

  def eff_date_text
    eff_date_label.delete('Eff.')
  end

end