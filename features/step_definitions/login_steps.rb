When("I attempt to log in") do
  on(LoginPage).populate
end

Then("I {should} be logged in") do |flag|
  if flag
    @browser.span( id: ':TabLinkMenuButton-btnIconEl').click
    logout_text = @browser.span( id: 'TabBar:LogoutTabBarLink-textEl').text
    expect(logout_text).to include('Log Out')
  else
    expect(@browser.span( id: ':TabLinkMenuButton-btnIconEl')).to be_visble
  end
end
