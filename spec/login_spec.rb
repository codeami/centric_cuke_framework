RSpec.describe 'Scifinder Login Page @login' do
  it 'should have a title' do
    visit(LoginPage)
    expect(@browser.title).to include('SciFinder')
  end

  it 'logs in properly' do
    visit(LoginPage).login
    expect(@browser.title).to include('Search')
  end
end
