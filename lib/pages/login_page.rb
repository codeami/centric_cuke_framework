
class LoginPage < PolicyCenterPage
  text_field(:user, id: 'Login:LoginScreen:LoginDV:username-inputEl')
  text_field(:password, id: 'Login:LoginScreen:LoginDV:password-inputEl')
  link(:submit, id: 'Login:LoginScreen:LoginDV:submit')

  def login()
    return if north_panel?
    populate
    submit
    Watir::Wait.until { north_panel? }
  end
end