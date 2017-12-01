
class LoginPage < BasePage
  page_url "#{Nenv.base_url}/ClaimCenter.do"

  text_field(:username, id: 'Login:LoginScreen:LoginDV:username-inputEl')
  text_field(:password, id: 'Login:LoginScreen:LoginDV:password-inputEl')
  span_button(:login, id: 'Login:LoginScreen:LoginDV:submit-btnInnerEl')


  def login_as(user, pass)
    self.username = user
    self.password = pass
    self.login
  end

  def populate(data = {}, additional = {})
    super
    self.login
  end

end