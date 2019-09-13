# frozen_string_literal: true
Given('valid credentials') do

end

Given(/I have logged into Policy Center/) do

  @browser.goto  'https://t1pc.wrg-ins.net:8543/PolicyCenter.do' # 'http://localhost:8180/pc/PolicyCenter.do'

  on(LoginPage).login
end

When(/I log out/) do
  on(PolicyCenterPage).north_panel.show_gear_menu.log_out
end

When('I attempt to log in') do
  @browser.goto 'http://localhost:8180/pc/PolicyCenter.do'
  on(LoginPage).login
end

Then('I {should} be logged in') do |flag|
  on(PolicyCenterPage) do |page|
    expect(page.north_panel?).to eq(flag)
  end
end
