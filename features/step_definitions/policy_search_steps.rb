# frozen_string_literal: true

When(/I search for policy number (.*) using the search tab/) do |policy_no|
  on(PolicyCenterPage).north_panel.show_search_tab
  on(SearchTabPage) do |page|
    @searched_for_policy_no = policy_no
    page.policy_number = policy_no
    page.search
    page.wait_for_results
  end
end

When(/I search for policy number (.*) using the drop down/) do |policy_no|
  @searched_for_policy_no = policy_no
  on(PolicyCenterPage).north_panel.search_for_policy_by_pol_no(policy_no)
end

Then(/I should be able to find that policy number in the grid/) do
  on(SearchTabPage) do |page|
    actual = page.policy_search_results.any? { |r| r.policy_number == @searched_for_policy_no }
    expect(actual).to eq(true), "Could not find policy number #{@searched_for_policy_no} in the results"
  end
end

And(/I click on the policy number in the results/) do
  on(SearchTabPage) do |page|
    result = page.policy_search_results.detect { |r| r.policy_number == @searched_for_policy_no }
    result.open_policy
  end
end

Then(/I should be on the policy tab viewing the searched for policy/) do
  on(PolicyTabPage) do |page|
    actual = page.policy_number
    expect(actual).to eq(@searched_for_policy_no), "Policy number on page (#{actual}) does not match expected value of #{@searched_for_policy_no}"
  end
end
