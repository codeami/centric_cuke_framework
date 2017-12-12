# frozen_string_literal: true

require 'page-object'
require 'data_magic'
require 'facets/string/snakecase'

# Base class for all pages in the framework
class BasePage
  include PageObject
  include DataMagic
  include PageFactory

  def populate(data = {}, additional = {})
    populate_page_with(data_for_or_default(self.class.to_s.snakecase, default_data, additional)) if data.empty?
    populate_page_wth(data) unless data.empty?
  end

  # Base classes should override this to provide default data
  def default_data
    {}
  end
end
