# frozen_string_literal: true

# Model of the login page
class LoginPage < PolicyCenterPage
  text_field(:user, id: 'Login:LoginScreen:LoginDV:username-inputEl')
  text_field(:password, id: 'Login:LoginScreen:LoginDV:password-inputEl')
  link(:submit, id: 'Login:LoginScreen:LoginDV:submit')

  # Login using data from a fixture.  Safe to call if already logged in
  def login
    return if north_panel?

    populate
    submit
    Watir::Wait.until { north_panel? }
  end
end
