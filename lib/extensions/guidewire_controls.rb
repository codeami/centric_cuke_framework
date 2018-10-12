# frozen_string_literal: true

require 'cpt_hook'
require 'page-object/accessors'

# Rubocop has problems with metaprogramming...
module PageObject

  class GWSelectList < SimpleDelegator

    def value
      edit.value
    end

    def text
      value
    end

    def set(value)
      edit.set(value)
    end

    def show_list
      dd_toggle.click unless list_open?
    end

    def close_list
      dd_toggle.click if list_open?
    end

    def list_open?
      class_name.include? 'x-pickerfield-open'
    end

    def select_item(value)
      show_list
      list.select_item(value)
    end

    private

    def list
      list_el = div( xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-boundlist-floating')]")
      GWBoundListFloating.new(list_el, class: 'x-boundlist-item')
    end

    def edit
      text_field( role: 'combobox')
    end

    def dd_toggle
      div(class: 'x-form-trigger')
    end
  end

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
      #binding.pry
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
      #binding.pry;2
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

  class GWBoundListFloating < SimpleDelegator
    def initialize(element, item_selector)
      super(element)
      @item_selector = item_selector
    end

    def items
      item_elements.map { |e| e.text }
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
      retry
    end

    def items
      item_divs.to_a.map { |div| @item_class.new(div, @element, @parent) }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
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
      divs(@item_sel)
    end
  end

  class GWRadioButton < SimpleDelegator
    def initialize(element, set_classname, label_selector)
      super(element)
      @set_classname = set_classname
      @label_selector = label_selector
    end

    def label
      super(@label_selector)
    end

    def text
      label.text
    end

    def set?
      div.class_name.include? @set_classname
    end

    def set
      return if set?
      button.focus
      button.click
    end
  end

  class GWRadioButtonArray < SimpleDelegator
    def initialize(element, set_classname, label_selector)
      super(element)
      @set_classname = set_classname
      @label_selector = label_selector
    end

    def items
      Watir::Wait.until { present? }
      tds(role: 'presentation').map { |b| GWRadioButton.new(b, @set_classname, @label_selector) }
    end

    def selected_item
      items.detect { |i| i.set? }
    end

    def to_h
      items.flat_map { |i| { i.label => i.set? } }
    end

    def select(str_or_regex)
      item = items.detect { |i| str_or_regex.is_a?(Regexp) ? str_or_regex.match(i.text) : i.text == str_or_regex }
      raise "Could not locate a radio button matching #{str_or_regex}." unless item
      item.set
    end
  end

  class GWCheckBox < GWRadioButton
    alias_method :checked?, :set?
    alias_method :check, :set

    def uncheck
      click if checked?
    end
  end

  # Contains the class level methods that are inserted into your page objects
  # when you include the PageObject module.  These methods will generate another
  # set of methods that provide access to the elements on the web pages.
  #
  module Accessors

    def gw_dropdown_cell(name, identifier, &block)
      list_sel = identifier.delete(:list) || { xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-boundlist-floating')]" }
      item_sel = identifier.delete(:items) || { class: 'x-boundlist-item' }
      _hooked_methods = hooked_sm_em(name, identifier, 'div_for', "#{name}_po_element", &block)

      define_method("#{name}_element") do
        begin
          return GWDropdownCell.new(send("#{name}_po_element"), list_sel, item_sel)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end

      define_method(name) do
        send("#{name}_element")
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end
    end

    def gw_bound_list_floating(name, identifier, &block)
      item_sel = identifier.delete(:items) || { class: 'x-boundlist-item' }
      _hooked_methods = hooked_sm_em(name, identifier, 'div_for', "#{name}_po_element", &block)

      define_method("#{name}_element") do
        begin
          return GWBoundListFloating.new(send("#{name}_po_element"), item_sel)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end

      define_method(name) do
        send("#{name}_element")
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end
    end

    def gw_radio_array(name, identifier, &block)
      label_sel = identifier.delete(:label) || { class: 'x-form-cb-label' }
      set_class = identifier.delete(:set_class) || 'x-form-cb-checked'
      _hooked_methods = hooked_sm_em(name, identifier, 'div_for', "#{name}_po_element", &block)

      define_method("#{name}_element") do
        begin
          return GWRadioButtonArray.new(send("#{name}_po_element"), set_class, label_sel)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end

      define_method(name) do
        send("#{name}_element").selected_item&.text
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select(value)
      end
    end

    # TODO: This is a bit of a hack.  Need to plum this into PageObject
    def grid_view(name, item_class, identifier, &block)
      item_sel = identifier.delete(:item_sel) || { class: 'x-grid-item-container' }
      _hooked_methods = hooked_standard_methods(name, identifier, 'div_for', &block)

      define_method(name) do
        begin
          return GridView.new(send("#{name}_element"), item_class, item_sel, self)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end
    end

    def gw_select_list(name, identifier = { index: 0 }, &block)
      _hooked_methods = hooked_sm_em(name, identifier, 'div_for', "#{name}_po_element", &block)
      define_method(name) do
        send("#{name}_element").value
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end

      define_method("#{name}_element") do
        begin
          return GWSelectList.new(send("#{name}_po_element"))
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end
    end

    # TODO: This is a TERRIBLE name
    # For text fields which cause other fields to show up
    def revealing_text_field(name, finder_method, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'text_field_for', &block)
      define_method(name) do
        return platform.text_field_value_for identifier.clone unless block_given? || hooked_methods.include?(:value)
        send("#{name}_element").value
      end
      define_method("#{name}=") do |value|
        ele = send("#{name}_element")
        ele.value = value
        ele.send_keys :tab
        Watir::Wait.until { finder_method.is_a?(Proc) ? finder_method.call : self.send(finder_method) }
      end
    end
  end
end
