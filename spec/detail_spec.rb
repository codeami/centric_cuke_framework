RSpec.describe ('Result Details @detail') do
  it('displays the substance detail for the given search') do
    visit(LoginPage).login
    PageNavigationHelper.visit_detail('107-44-8', 'Substances')
    #expect(browser.getTitle()).toContain('Substance Detail')
  end

  it('displays the substance detail from a reaction search') do
    #browser.currentPage = new LoginPage()
    #browser.currentPage.loginWithNavigation()
    #browser.currentPage.search('107-44-8', 'Reactions')
    #PageNavigation.visitDetail('107-44-8', 'Substances')
    #expect(browser.getTitle()).toContain('Substance Detail')
  end
end
