# frozen_string_literal: true


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

  def change_page_using(element, opts = {})
    opts[:current_url] = @browser.url

    begin
      send(element.to_sym)
    rescue
      # wait_for_ajax
      send(element.to_sym)
    end

    wait_for_url_change(opts)
  end

  def wait_for_url_change(opts = {})
    url_now = opts.fetch(:current_url, @browser.url)
    Watir::Wait.until { @browser.url != url_now }
    wait_for_ajax
  end
end
