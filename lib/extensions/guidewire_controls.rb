# frozen_string_literal: true

require 'cpt_hook'
require 'page-object/accessors'

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
    def initialize(element, list_selector, item_selector)
      super(element)
      @item_selector = item_selector
      @list_selector = list_selector
    end

    def open?
      class_name.include? 'x-btn-menu-active'
    end

    def open
      click unless open?
    end

    def close
      click if open?
    end

    def closed?
      !open?
    end

    def list
      open
      @list ||= GWBoundListFloating.new(list_element, @item_selector)
    end

    def select_item(str_or_regex)
      list.select_item str_or_regex
    end
    alias set select_item

    def value
      text
    end

    def list_element
      div(@list_selector)
    end
  end

  # Variant of the GWDropdown that lives inside a td
  class GWDropdownCell < SimpleDelegator
    def initialize(element, list_selector, item_selector)
      super(element)
      @item_selector = item_selector
      @list_selector = list_selector
    end

    def edit_mode?
      style.include? 'visibility: hidden;'
    end

    def text
      edit_mode? ? editor.value : super
    end

    def show_dd
      click unless edit_mode?
    end

    def list
      show_dd
      @list ||= GWBoundListFloating.new(list_element, @item_selector)
    end

    def editor
      div(xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-editor')]").text_field
    end

    def set(value)
      show_dd
      editor.when_present.set(value)
      editor.send_keys(:tab)
    end

    def select_item(str_or_regex)
      list.select_item str_or_regex
      editor.send_keys(:tab)
    end

    def list_element
      div(@list_selector)
    end
  end

  # Handles the various popup menus
  class GWBoundListFloating < SimpleDelegator
    def initialize(element, item_selector)
      super(element)
      @item_selector = item_selector
    end

    def items
      item_elements.map(&:text)
    end

    def select_item(str_or_regex)
      item = item_elements.detect { |i| str_or_regex.is_a?(Regexp) ? str_or_regex.match(i.text) : i.text == str_or_regex }
      raise "Could not locate a list item matching #{str_or_regex}." unless item

      item.click
      item.text
    end

    def item_elements
      elements(@item_selector)
    end
  end

  # A class for handling the data grids.
  class GridView < SimpleDelegator
    def initialize(element, item_class, item_sel, parent)
      super(element)
      @item_class = item_class
      @parent = parent
      @item_sel = item_sel
    end

    def count
      item_divs.count
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      # rubocop:disable Lint/Debugger
      binding.pry if Nenv.debug?
      STDOUT.puts 'Line for pry' if Nenv.debug?
      # rubocop:enable Lint/Debugger
      retry
    end

    def items
      item_divs.to_a.map { |div| @item_class.new(div, @element, @parent) }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      # rubocop:disable Lint/Debugger
      binding.pry if Nenv.debug?
      STDOUT.puts 'Line for pry' if Nenv.debug?
      # rubocop:enable Lint/Debugger
      retry
    end

    def wait_for_items
      Watir::Wait.until { present? && count.positive? }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def wait_for_no_items
      Watir::Wait.until { present? && count.zero? }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def wait_for_count_change(last_count = nil)
      last_count ||= count
      Watir::Wait.until { present? && count != last_count }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def trigger_count_change
      last_count = count
      yield
      wait_for_count_change(last_count)
    end

    def find_item(method, str_or_regex)
      items.detect { |p| str_or_regex.is_a?(Regexp) ? str_or_regex.match(p.send(method)) : p.send(method) == str_or_regex }
    end

    def find_items(method, str_or_regex)
      items.select { |p| str_or_regex.is_a?(Regexp) ? str_or_regex.match(p.send(method)) : p.send(method) == str_or_regex }
    end

    def any?(method, str_or_regex)
      items.any? { |p| str_or_regex.is_a?(Regexp) ? str_or_regex.match(p.send(method)) : p.send(method) == str_or_regex }
    end

    def all?(method, str_or_regex)
      items.all? { |p| str_or_regex.is_a?(Regexp) ? str_or_regex.match(p.send(method)) : p.send(method) == str_or_regex }
    end

    private

    def item_divs
      trs(@item_sel)
    end
  end
end
