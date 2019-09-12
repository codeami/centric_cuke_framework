class CreateAccountPage < PolicyCenterPage
  gw_form_set(:account_details, id: 'CreateAccount:CreateAccountScreen:CreateAccountDV-table')

  link_hooked(:update, id: 'CreateAccount:CreateAccountScreen:Update', hooks: WFA_HOOKS)

  def populate(data = nil)
    data ||= data_for 'create_account_page'
    account_details.set(data[:account_details.to_s])
  end

  def populate_and_update(data = nil)
    begin
      populate(data)
    rescue
      binding.pry
      STDOUT.puts
    end
    update
  end
end