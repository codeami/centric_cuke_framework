class CreateAccountPage < PolicyCenterPage
  #gw_form_set(:account_details, xpath: '//*[@id="CreateAccount"]/table')
  gw_table_select_list(:profit_center_accoount, id: 'CreateAccount:CreateAccountScreen:ProfictCenterAccounttype', hooks: WFA_HOOKS)
  text_area_hooked(:name, id: 'CreateAccount:CreateAccountScreen:CreateAccountContactInputSet:GlobalContactNameInputSet:Name-inputEl', hooks: WFA_HOOKS)
  text_area_hooked(:name_print_version, id: 'CreateAccount:CreateAccountScreen:CreateAccountContactInputSet:GlobalContactNameInputSet:NameMedium-inputEl', hooks: WFA_HOOKS)
  text_field_hooked(:office_phone, id: 'CreateAccount:CreateAccountScreen:CreateAccountContactInputSet:Phone:GlobalPhoneInputSet:NationalSubscriberNumber-inputEl', hooks: WFA_HOOKS)
  text_field_hooked(:fax, id: 'CreateAccount:CreateAccountScreen:CreateAccountContactInputSet:FaxPhone:GlobalPhoneInputSet:NationalSubscriberNumber-inputEl', hooks: WFA_HOOKS)
  text_field_hooked(:primary_email, id: 'CreateAccount:CreateAccountScreen:CreateAccountContactInputSet:EmailAddress1-inputEl', hooks: WFA_HOOKS)
  text_field_hooked(:secondary_email, id: 'CreateAccount:CreateAccountScreen:CreateAccountContactInputSet:EmailAddress2-inputEl', hooks: WFA_HOOKS)
  text_field_hooked(:address_1, id: 'CreateAccount:CreateAccountScreen:Addresses:CreateAccountDV:AddressInputSet:globalAddressContainer:GlobalAddressInputSet:AddressLine1-inputEl', hooks: WFA_HOOKS)
  text_field_hooked(:address_2, id: 'CreateAccount:CreateAccountScreen:Addresses:CreateAccountDV:AddressInputSet:globalAddressContainer:GlobalAddressInputSet:AddressLine2-inputEl', hooks: WFA_HOOKS)
  text_field_hooked(:city, id: 'CreateAccount:CreateAccountScreen:Addresses:CreateAccountDV:AddressInputSet:globalAddressContainer:GlobalAddressInputSet:City-inputEl', hooks: WFA_HOOKS)
  text_field_hooked(:county, id: 'CreateAccount:CreateAccountScreen:Addresses:CreateAccountDV:AddressInputSet:globalAddressContainer:GlobalAddressInputSet:County-inputEl', hooks: WFA_HOOKS)
  gw_table_select_list(:state, id: 'CreateAccount:CreateAccountScreen:Addresses:CreateAccountDV:AddressInputSet:globalAddressContainer:GlobalAddressInputSet:State-triggerWrap', hooks: WFA_HOOKS)
  text_field_hooked(:zip_code, id: 'CreateAccount:CreateAccountScreen:Addresses:CreateAccountDV:AddressInputSet:globalAddressContainer:GlobalAddressInputSet:PostalCode-inputEl', hooks: WFA_HOOKS)
  text_field_hooked(:fein, id: 'CreateAccount:CreateAccountScreen:Addresses:CreateAccountDV:OfficialIDInputSet:OfficialIDDV_Input-inputEl', hooks: WFA_HOOKS)
  text_field_hooked(:ssn, id: 'CreateAccount:CreateAccountScreen:Addresses:CreateAccountDV:OfficialIDInputSet:OfficialIDSSNDV_Input-inputEl', hooks: WFA_HOOKS)
  gw_table_select_list(:business_entity_type, id: 'CreateAccount:CreateAccountScreen:Addresses:CreateAccountDV:businssDetails:OrgType', hooks: WFA_HOOKS)
  text_field_hooked(:year_business_started, id: 'CreateAccount:CreateAccountScreen:Addresses:CreateAccountDV:businssDetails:YearBusinessStarted-inputEl', hooks: WFA_HOOKS)
  text_area_hooked(:description_of_business, id: 'CreateAccount:CreateAccountScreen:Addresses:CreateAccountDV:businssDetails:DescriptionOfBusiness-inputEl', hooks: WFA_HOOKS)
  text_field_hooked(:organization, id: 'CreateAccount:CreateAccountScreen:Addresses:CreateAccountDV:ProducerSelectionInputSet:Producer-inputEl', hooks: WFA_HOOKS)
  gw_table_select_list(:producer_code, id: 'CreateAccount:CreateAccountScreen:Addresses:CreateAccountDV:ProducerSelectionInputSet:ProducerCode-inputEl', hooks: WFA_HOOKS)
  link_hooked(:update, id: 'CreateAccount:CreateAccountScreen:Update', hooks: WFA_HOOKS)

  def populate(data = nil)
    data ||= data_for 'create_account_page'
    account_details.set(data[:account_details.to_s])
  end

  def populate_and_update(data = nil)
    begin
      populate(data)
    rescue Exception => e
      binding.pry
      STDOUT.puts
    end
    update
  end
end