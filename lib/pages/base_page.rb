# frozen_string_literal: true

require 'data_magic'
require 'facets/string/snakecase'

# Base class for all pages in the framework
#
# This page class overrides the PageObject population mechanisms so that:
#   1. Pages are populated automatically if no data is provided to populate
#   2. Values are populated via the setters on the page instead of PageObject code
class BasePage
  include PageObject
  include DataMagic
  include PageFactory

  # populate the page with data, if data is not provided it will be pulled from data magic
  #
  def populate(data = {}, additional = {})
    populate_page_with(data_for_or_default(self.class.to_s.snakecase, default_data, additional)) if data.nil? || data.empty?
    populate_page_with(data) unless data.nil? || data.empty?
  end

  # Define populate_value so that if we define a key= method it gets called instead of PageObject barfing on us when we're
  # not dealing with something that's an element.
  def populate_value(receiver, key, value)
    return send("#{key}=", value) if respond_to?("#{key}=")

    populate_checkbox(receiver, key, value) if is_checkbox?(receiver, key) && is_enabled?(receiver, key)
    populate_radiobuttongroup(receiver, key, value) if is_radiobuttongroup?(receiver, key)
    populate_radiobutton(receiver, key, value) if is_radiobutton?(receiver, key) && is_enabled?(receiver, key)
    populate_select_list(receiver, key, value) if is_select_list?(receiver, key)
    populate_text(receiver, key, value) if is_text?(receiver, key) && is_enabled?(receiver, key)
  end

  # Returns the div containing the currently active menu
  def active_menu
    div(xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-menu')]")
  end

  # Base classes should override this to provide default data
  def default_data
    {}
  end

  # Blocking navigation that waits for a url to change
  #
  # This useful for things like login and navigation links.
  #
  # page.change_page_using :login
  #
  # Would call the login method on the page, then wait for the URL to change to a new
  # value.
  #
  def change_page_using(element, opts = {})
    opts[:current_url] = @browser.url

    begin
      send(element.to_sym)
    rescue StandardError
      # wait_for_ajax
      send(element.to_sym)
    end

    wait_for_url_change(opts)
  end

  # Block until the browser URL changes.
  #
  # If the supplied options hash does not contain a :current_url key,
  # it will use the browser url.  This could lead to timing issues
  # so you should most likely make a note of the url before initiating the url change.
  #
  # The change_page_using method does this automatically.
  # @param opts [Hash] An options hash.
  def wait_for_url_change(opts = {})
    url_now = opts.fetch(:current_url, @browser.url)
    Watir::Wait.until { @browser.url != url_now }
    wait_for_ajax
  end
end
