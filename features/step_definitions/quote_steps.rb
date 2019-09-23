# frozen_string_literal: true

And(/I create a new policy quote/) do
  on(PolicyCenterPage) do |page|
    page.north_panel.new_policy
  end

  on(NewSubmissionTabPage, &:populate)

  on(SubmissionTabPage) do |page|
    page.wizard_panel.populate_to :forms
  end
end
