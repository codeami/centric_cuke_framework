# Helper functions for routes that are too complicated for PageObject routes

module PageNavigationHelper
  include ::PageObject::PageFactory
  def self.visit_detail(query, search_type, options = nil)
    on(SearchPage) do |page|
      page.search(query, search_type)
      page.navigate_to_detail(query, options)
    end
  end
end
