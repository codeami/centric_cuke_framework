# frozen_string_literal: true

# Represents the policy tab
class PolicyTabPage < PolicyCenterPage
  span(:policy_number, xpath: '//*[@id="PolicyFile:PolicyFileMenuInfoBar:PolicyNumber-btnInnerEl"]/span[2]')
end
