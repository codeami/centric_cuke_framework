And(/^I create a new (.*) account from my fixture file$/) do |acc_type|

  on(PolicyCenterPage).north_panel.new_account
  on(NewAccountSearchPage).wait_for_ajax

  binding.pry
  on(NewAccountSearchPage).create_new_account(acc_type.downcase)
  on(CreateAccountPage).populate_and_update
end