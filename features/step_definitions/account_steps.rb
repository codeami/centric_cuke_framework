And(/^I create a new (.*) account from my fixture file$/) do |acc_type|
  on(PolicyCenterPage).north_panel.new_account
  on(NewAccountSearchPage).create_new_account(acc_type.downcase)
  on(CreateAccountPage).populate_and_update
end

And(/^I add a new product to my new account$/) do
  on(AccountFileSummaryPage).new_submission
  on(NewSubmissionsPage).add_bop

  on(SubmissionTabPage) do |page|
    #binding.pry
    page.wizard_panel.populate_to :forms
  end
end