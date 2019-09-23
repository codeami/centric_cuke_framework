# frozen_string_literal: true

# Partial model of the WRG new account search page.
class NewAccountSearchPage < PolicyCenterPage
  text_area_hooked(:company_name, name: 'NewAccount:NewAccountScreen:NewAccountSearchDV:GlobalContactNameInputSet:Name', hooks: WFA_HOOKS)
  text_field_hooked(:city, name: 'NewAccount:NewAccountScreen:NewAccountSearchDV:AddressOwnerAddressInputSet:globalAddressContainer:GlobalAddressInputSet:City', hooks: WFA_HOOKS)
  text_field_hooked(:county, name: 'NewAccount:NewAccountScreen:NewAccountSearchDV:AddressOwnerAddressInputSet:globalAddressContainer:GlobalAddressInputSet:County', hooks: WFA_HOOKS)
  gw_table_select_list(:state, id: 'NewAccount:NewAccountScreen:NewAccountSearchDV:AddressOwnerAddressInputSet:globalAddressContainer:GlobalAddressInputSet:State', hooks: WFA_HOOKS)
  link_hooked(:search, id: 'NewAccount:NewAccountScreen:NewAccountSearchDV:SearchAndResetInputSet:SearchLinksInputSet:Search', hooks: WFA_HOOKS)

  link_hooked(:new_account_company, id: 'NewAccount:NewAccountScreen:NewAccountButton:NewAccount_Company-itemEl', hooks: WFA_HOOKS)
  link_hooked(:new_account_person, id: 'NewAccount:NewAccountScreen:NewAccountButton:NewAccount_Person-itemEl', hooks: WFA_HOOKS)
  link_hooked(:new_account_button, id: 'NewAccount:NewAccountScreen:NewAccountButton', hooks: WFA_HOOKS)

  # Given an account type, and (optionally) some data create a new account
  #
  # If data is not provided it will be pulled from fixtures.
  #
  # Once this method ends you will be on the CreateAccountPage.
  def create_new_account(acc_type, data = nil)
    wait_for_ajax
    populate(data)
    search
    new_account_button
    send("new_account_#{acc_type}")
  end
end
