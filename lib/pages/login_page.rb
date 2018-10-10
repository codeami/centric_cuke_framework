
class LoginPage < BasePage
  page_url 'http://localhost:8180/pc/PolicyCenter.do'
  text_field(:user, id: 'Login:LoginScreen:LoginDV:username-inputEl')
  text_field(:password, id: 'Login:LoginScreen:LoginDV:password-inputEl')
  link(:submit, id: 'Login:LoginScreen:LoginDV:submit')

  def login(id = 'SCICASPDF20', pw = '996Y002')
    self.user = id
    self.password = pw
    change_page_using(:submit)
  end
end