
And(/I create a new policy quote/) do
  on(PolicyCenterPage) do |page|
    page.north_panel.new_policy
  end

  on(NewSubmissionTabPage) do |page|
    page.populate
  end

  on(SubmissionTabPage) do |page|
    qs = page.bop_offering_questions
    vals = { is_the_customer_based_in_british_columbia: true, is_the_customer_a_member_of_partners_alliance: true }
    qs.set vals
    qs.pry
  end

end
