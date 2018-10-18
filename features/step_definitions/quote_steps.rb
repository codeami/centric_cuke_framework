
And(/I create a new policy quote/) do
  on(PolicyCenterPage) do |page|
    page.north_panel.new_policy
  end

  on(NewSubmissionTabPage) do |page|
    page.populate
  end

  on(SubmissionTabPage) do |page|
    #binding.pry
    page.wizard_panel.populate_to :policy_info
    d = page.wizard_panel.current_details
    p = d.policy_info
    p.pry
    binding.pry
  end

end
