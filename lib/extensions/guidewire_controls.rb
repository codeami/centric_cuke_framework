# frozen_string_literal: true

require 'cpt_hook'
require 'page-object/accessors'

# module to hold Guidwire specific code
module GuideWire
  class << self
    def question_types
      @question_types ||= {}
    end
  end
end

# Rubocop has problems with metaprogramming...
module PageObject
  # Handle the special select lists that aren't really select lists inside guidewire
  class GWSelectList < SimpleDelegator
    def value
      edit.value
    end

    def text
      value
    end

    def set(value)
      edit.click
      edit.set(value)
      edit.send_keys :tab
    end

    def show_list
      until list_open?
        dd_toggle.click!
        sleep 0.3
      end
    end

    def close_list
      dd_toggle.click! if list_open?
    end

    def list_open?
      class_name.include?('x-pickerfield-open') || tds(class: 'x-pickerfield-open').count.positive? || list_element.present?
    end

    def select_item(value)
      show_list
      list.select_item(value)
    end

    private

    def list_element
      div(xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-boundlist-floating')]", visible: true)
    end

    def list
      GWBoundListFloating.new(list_element, class: 'x-boundlist-item')
    end

    def edit
      text_field(role: 'combobox')
    end

    def dd_toggle
      div(class: 'x-form-trigger')
    end
  end

  # A wrapper for items within the tree nav
  class GWTreeNavItem < SimpleDelegator
    def items
      @items ||= []
    end
  end

  # Class to represent a panel within the tree nav
  class GWTreeNavPanel < SimpleDelegator
    def initialize(element)
      super
      add_methods
    end

    def title
      div(class: 'x-title-item').text
    end

    def add_methods
      items.each do |item|
        if item.items.count.positive?
          item.items.each { |i| add_method_for_item(i, item) }
        else
          add_method_for_item(item)
        end
      end
    end

    def add_method_for_item(item, parent = nil)
      method_name = parent.nil? ? item.text : "#{parent.text}_#{item.text}"
      define_singleton_method(method_name.snakecase) do
        item.click
      end
    end

    def items
      @items ||= fetch_items
    end

    def subtitle
      span(class: '')
    end

    private

    def fetch_items
      results = []
      last_item = nil
      tree_view_div.tds(class: 'x-grid-cell').each do |cell|
        # TODO: This only handles two levels deep
        if cell.class_name.include?('g-accordion-depth-1')
          last_item = GWTreeNavItem.new(cell)
          results << last_item
        else
          last_item.items << cell
        end
      end
      results
    end

    def tree_view_div
      div(class: 'x-tree-view')
    end

    def title_div
      div(class: 'x-title-text')
    end
  end

  # Class for handling the disconnected dropdown menus
  # In can open the list and select from the resulting menu
  class GWDropdown < SimpleDelegator
    # duh
    def initialize(element, list_selector, item_selector)
      super(element)
      @item_selector = item_selector
      @list_selector = list_selector
    end

    # Returns true if the dropdown is open
    def open?
      class_name.include? 'x-btn-menu-active'
    end

    # Opens the list unless already open
    def open
      click unless open?
    end

    # Closes the list if open
    def close
      click if open?
    end

    # Returns true if the list is closed
    def closed?
      !open?
    end

    # Returns a GWBoundListFloating for this dropdown
    def list
      open
      @list ||= GWBoundListFloating.new(list_element, @item_selector)
    end

    # Select an item from the list using a string or regex
    def select_item(str_or_regex)
      list.select_item str_or_regex
    end
    alias set select_item

    # Returns the text
    def value
      text
    end

    # Helper function to look up  the list
    def list_element
      div(@list_selector)
    end
  end

  # Variant of the GWDropdown that lives inside a td
  class GWDropdownCell < SimpleDelegator
    # yay new things
    def initialize(element, list_selector, item_selector)
      super(element)
      @item_selector = item_selector
      @list_selector = list_selector
    end

    # Returns true if the control is in edit mode
    def edit_mode?
      style.include? 'visibility: hidden;'
    end

    # Returns the text, either from the dropdown or the editor, whichever is active
    def text
      edit_mode? ? editor.value : super
    end

    # Show the dropdown unless in edit mode
    def show_dd
      click unless edit_mode?
    end

    # Returns a GWBoundListFloating for this dropdown
    def list
      show_dd
      @list ||= GWBoundListFloating.new(list_element, @item_selector)
    end

    # Helper function to find the editor
    def editor
      div(xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-editor')]").text_field
    end

    # Set the value of the dropdown by activating the editor, setting it, and tabbing out
    def set(value)
      show_dd
      editor.when_present.set(value)
      editor.send_keys(:tab)
    end

    # Selects a value from the dropdown, then tabs out
    def select_item(str_or_regex)
      list.select_item str_or_regex
      editor.send_keys(:tab)
    end

    # Helper function to find the bound list
    def list_element
      div(@list_selector)
    end
  end

  # Handles the various popup menus
  class GWBoundListFloating < SimpleDelegator
    # More new stuff
    def initialize(element, item_selector)
      super(element)
      @item_selector = item_selector
    end

    # Returns the text of all the items
    def items
      item_elements.map(&:text)
    end

    # Select an item from the list using a string or regex
    def select_item(str_or_regex)
      item = item_elements.detect { |i| str_or_regex.is_a?(Regexp) ? str_or_regex.match(i.text) : i.text == str_or_regex }
      raise "Could not locate a list item matching #{str_or_regex}." unless item

      item.click
      item.text
    end

    # Helper function to find all the items in the list
    def item_elements
      elements(@item_selector)
    end
  end

  # A class for handling the data grids.
  class GridView < SimpleDelegator
    # Newness
    def initialize(element, item_class, item_sel, parent)
      super(element)
      @item_class = item_class
      @parent = parent
      @item_sel = item_sel
    end

    # Returns the count of the items in the grid
    def count
      item_divs.count
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      # rubocop:disable Lint/Debugger
      binding.pry if Nenv.cuke_debug?
      STDOUT.puts 'Line for pry' if Nenv.cuke_debug?
      # rubocop:enable Lint/Debugger
      attempts ||= 0
    attempts += 1
    binding.pry if Nenv.cuke_debug?
    retry unless attempts > 3
    end

    # Maps all of the item divs into their item class.
    def items
      item_divs.to_a.map { |div| @item_class.new(div, @element, @parent) }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      # rubocop:disable Lint/Debugger
      binding.pry if Nenv.cuke_debug?
      STDOUT.puts 'Line for pry' if Nenv.cuke_debug?
      # rubocop:enable Lint/Debugger
      attempts ||= 0
    attempts += 1
    binding.pry if Nenv.cuke_debug?
    retry unless attempts > 3
    end

    # Block until we have items
    def wait_for_items
      Watir::Wait.until { present? && count.positive? }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      attempts ||= 0
    attempts += 1
    binding.pry if Nenv.cuke_debug?
    retry unless attempts > 3
    end

    # Block until we don't have items
    def wait_for_no_items
      Watir::Wait.until { present? && count.zero? }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      attempts ||= 0
    attempts += 1
    binding.pry if Nenv.cuke_debug?
    retry unless attempts > 3
    end

    # Wait until the count changes from some value
    def wait_for_count_change(last_count = nil)
      last_count ||= count
      Watir::Wait.until { present? && count != last_count }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      attempts ||= 0
    attempts += 1
    binding.pry if Nenv.cuke_debug?
    retry unless attempts > 3
    end

    # Syntatic sugar for when you know you're going to trigger a count change
    # This will call your block then block until the count changes
    #
    # page.trigger_account_change { some_item.delete}
    #
    def trigger_count_change
      last_count = count
      yield
      wait_for_count_change(last_count)
    end

    # Find a single item using a method and a string or regex
    #
    # item = grid.find_item(:last_name, 'Smith')
    #
    def find_item(method, str_or_regex)
      items.detect { |p| str_or_regex.is_a?(Regexp) ? str_or_regex.match(p.send(method)) : p.send(method) == str_or_regex }
    end

    # Find items using a method and a string or regex
    #
    # items = grid.find_items(:last_name, 'Smith')
    #
    def find_items(method, str_or_regex)
      items.select { |p| str_or_regex.is_a?(Regexp) ? str_or_regex.match(p.send(method)) : p.send(method) == str_or_regex }
    end

    # Returns true if any item matches the string or regex
    #
    # have_a_smith = grid.any?(:last_name, 'Smith')
    #
    def any?(method, str_or_regex)
      items.any? { |p| str_or_regex.is_a?(Regexp) ? str_or_regex.match(p.send(method)) : p.send(method) == str_or_regex }
    end

    # Returns true if all items matches the string or regex
    #
    # all_smiths = grid.all?(:last_name, 'Smith')
    #
    def all?(method, str_or_regex)
      items.all? { |p| str_or_regex.is_a?(Regexp) ? str_or_regex.match(p.send(method)) : p.send(method) == str_or_regex }
    end

    private

    # Helper function for finding the items
    def item_divs
      trs(@item_sel)
    end
  end
end
