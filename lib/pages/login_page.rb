class LoginPage < BasePage
  page_url Nenv.sfn_url
  text_field(:user, id: 'username')
  text_field(:password, id: 'password')
  button(:submit, text: 'Log In')

  def login(id = 'SCICASPDF20', pw = '996Y002')
    self.user = id
    self.password = pw
    change_page_using(:submit)
  end
end