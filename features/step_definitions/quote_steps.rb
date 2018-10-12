
And(/I create a new policy quote/) do
  on(PolicyCenterPage) do |page|
    page.north_panel.new_policy
  end

  on(NewSubmissionTabPage) do |page|
    page.populate
  end

  on(SubmissionTabPage) do |page|

    binding.pry
    page.wizard_panel.populate_to_end

  end

end
