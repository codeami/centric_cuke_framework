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
      list_el = div( xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-boundlist-floating')]", visible: true)
      GWBoundListFloating.new(list_el, class: 'x-boundlist-item')
    end

    def edit
      text_field( role: 'combobox')
    end

    def dd_toggle
      div(class: 'x-form-trigger')
    end
  end

  class GWQuestionSetQuestion < SimpleDelegator
    attr_reader :question_type
    def initialize(element, question_type)
      super(element)
      @question_type = question_type
    end

    def key
      @key ||= "#{text.snakecase.gsub( /[^\w\d\s_]/, '')}_#{question_type}" #.to_sym
    end

    def text
      td.text
    end

    def to_h
      { key =>  {text: text, value: value } }
    end

    def self.has_triggers?(element)
      element.divs( class: 'x-form-trigger').count.positive?
    end

    def self.actionable?(element)
      element.links(class: 'g-actionable').count.positive?
    end
  end

  class GWQuestionSetYNQuestion < GWQuestionSetQuestion
    attr_reader :question_type
    def initialize(element)
      super(element, :yes_no)
      @label_sel =  { class: 'x-form-cb-label' }
      @set_class = 'x-form-cb-checked'
    end

    def pry
      binding.pry;2
      puts ''
    end

    def value
      item = answers.selected_item
      return nil unless item
      item.text == 'Yes'
    end

    def answer
      answers.selected_item&.text
    end

    def set(val)
      if val.is_a?(TrueClass) || val.is_a?(FalseClass)
        val = val ? 'Yes' : 'No'
      end
      answers.select(val.titlecase)
    end

    def answers
      @answers ||= GWRadioButtonArray.new(table(class: 'gw-radio-group-cell'),  @set_class, @label_sel)
    end

    def self.handle_element?(element)
      return false unless correct_input_count?(element)
      return false unless correct_labels?(element)
      true
    end

    private
    def self.correct_input_count?(element)
      return element.inputs(class: 'x-form-radio').count == 2
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_labels?(element)
      return element.labels.map(&:text).join == 'YesNo'
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  class GWFormYNQuestion < GWQuestionSetQuestion
    attr_reader :question_type
    def initialize(element)
      super(element, :yes_no)
      binding.pry
    end

    def pry
      binding.pry;2
      puts ''
    end

    def value
      item = answers.selected_item
      return nil unless item
      item.text == 'Yes'
    end

    def answer
      answers.selected_item&.text
    end

    def set(val)
      if val.is_a?(TrueClass) || val.is_a?(FalseClass)
        val = val ? 'Yes' : 'No'
      end
      answers.select(val.titlecase)
    end

    def answers
      binding.pry
      @answers ||= GWFormRadioButtonArray.new(div(index: 0))
    end

    def self.handle_element?(element)
      return false unless correct_input_count?(element)
      return false unless correct_labels?(element)
      true
    end

    private
    def self.correct_input_count?(element)
      return element.inputs(class: 'x-form-radio').count == 2
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_labels?(element)
      return element.labels.map(&:text).join == 'YesNo'
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end
  # GuideWire.question_types[:yes_no] = GWFormYNQuestion

  class GWQuestionSetSingleEditQuestion < GWQuestionSetQuestion
    attr_reader :question_type
    def initialize(element)
      super(element, :single_edit)
    end

    def pry
      binding.pry;2
      puts ''
    end

    def value
      edit_mode? ? editor.value : cell.text
    end



    def answer
      value
    end

    def show_editor
      click unless edit_mode?
    end

    def set(val)
      show_editor
      editor.set(val)
      editor.send_keys(:tab)
    end

    def self.handle_element?(element)
      return false unless correct_input_count?(element)
      return false unless correct_style?(element)
      true
    end

    def edit_mode?
      cell.div.style.include? 'visibility: hidden;'
    end

    private

    def cell
      td(class: 'g-cell-edit')
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def editor_div
      div(xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-grid-editor')]")
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def editor
      editor_div.text_field
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_input_count?(element)
      return element.inputs(class: 'x-form-radio').count == 0
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_style?(element)
      return element.tds(class: 'g-cell-edit').count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:single_edit] = GWQuestionSetSingleEditQuestion

  class GWQuestionSet < SimpleDelegator

    def initialize(element, row_selector, parent)
      super(element)
      @parent = parent
      @row_selector = row_selector
    end

    def set(values)
      return unless values
      values.each do |k, v|
        if @parent.respond_to?("#{k}=")
          @parent.send("#{k}=", v)
        else
          find_question(k)&.set(v)
        end
      end
    end

    def find_question(key)
      q = questions.detect { |q| q.key == key.to_s }
      return q if q
      @questions = nil
      q = questions.detect { |q| q.key == key.to_s }
      raise "Could not find a question matching #{key}" unless q
      q
    end

    def to_h
      Hash[*questions.map(&:to_h).collect{|h| h.to_a}.flatten]
    end

    def values
      vals = to_h.map { |k, v| { k => v[:value] } }
      { key => Hash[*vals.collect{|h| h.to_a}.flatten] }
    end

    def fixture_values
      STDOUT.puts YAML.dump(values)
    end

    def name
      td.text
    end

    def key
      @key ||= name.snakecase.gsub( /[^\w\d\s_]/, '')
    end

    def pry
      binding.pry;2
      puts ''
    end

    def _questions
      trs( @row_selector).map { |r| class_for_row(r) }.delete_if { |r| r.nil? }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def questions
      @questions ||= _questions
    end

    def class_for_row(r)
      return nil unless r.tds.count > 1 && r.labels(visible: true).count.positive?
      q_class = GuideWire.question_types.values.detect { |q| q.handle_element?(r) }
      # binding.pry unless q_class
      STDERR.puts "Unknown question type" unless q_class
      q_class.new(r) if q_class
    end
  end

  class GWFormSet < GWQuestionSet

    def initialize(element, row_selector, name, parent)
      super(element, row_selector, parent)
      @name = name
    end

    def _questions
      #divs( @row_selector).map { |r| class_for_row(r) }
      trs(role: 'presentation').map { |r| class_for_row(r) }.delete_if { |r| r.nil? }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      binding.pry
      retry
    end

    def name
      @name.to_s
    end

    def pry
      binding.pry;2
      puts ''
    end
  end

  class GWTreeNavItem < SimpleDelegator
    def items
      @sub_items ||= []
    end
  end

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
        unless cell.class_name.include?('g-accordion-depth-1')
          last_item.items << cell
        else
          last_item = GWTreeNavItem.new(cell)
          results << last_item
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
    alias_method :set, :select_item

    def value
      text
    end

    def list_element
      div(@list_selector)
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
      binding.pry
      retry
    end

    def items
      item_divs.to_a.map { |div| @item_class.new(div, @element, @parent) }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      binding.pry
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

    def value
      set?
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

  class GWFormRadioButton < SimpleDelegator
    def initialize(element)
      super(element)
    end

    def set?
      self.class_name.include? 'x-form-cb-checked'
    end

    def value
      set?
    end

    def text
      label(visible: true).text
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
      binding.pry
      Watir::Wait.until { present? }
      tds(role: 'presentation').map { |b| GWRadioButton.new(b, @set_classname, @label_selector) }
    end

    def text
      selected_item&.text
    end
    alias_method :value, :text


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

  class GWFormRadioButtonArray < SimpleDelegator
    def initialize(element)
      super(element)
    end

    def items
      Watir::Wait.until { present? }
      begin
        table.tables.map { |b| GWFormRadioButton.new(b) }
      rescue Exception => ex
        binding.pry
        STDOUT.puts
      end
    end

    def text
      selected_item&.text
    end
    alias_method :value, :text


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

    def gw_dropdown(name, identifier, &block)
      list_sel = identifier.delete(:list) || { xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-boundlist-floating')]" }
      item_sel = identifier.delete(:items) || { class: 'x-boundlist-item' }
      _hooked_methods = hooked_sm_em(name, identifier, 'link_for', "#{name}_po_element", &block)

      define_method("#{name}_element") do
        begin
          return GWDropdown.new(send("#{name}_po_element"), list_sel, item_sel)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          binding.pry
          retry
        end
      end

      define_method(name) do
        send("#{name}_element").text
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end
    end

    def gw_form_dropdown(name, identifier, &block)
      list_sel = identifier.delete(:list) || { xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-boundlist-floating')]" }
      item_sel = identifier.delete(:items) || { class: 'x-boundlist-item' }
      _hooked_methods = hooked_sm_em(name, identifier, 'div_for', "#{name}_po_element", &block)

      define_method("#{name}_element") do
        begin
          return GWDropdown.new(send("#{name}_po_element"), list_sel, item_sel)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end

      define_method(name) do
        send("#{name}_element").input.value
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end
    end

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
      _hooked_methods = gw_simple_sm(name, identifier, GWSelectList,'div_for', &block)
      define_method(name) do
        send("#{name}_element").value
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end
    end

    def gw_tab_set(name, identifier, &block)
      _hooked_methods = hooked_sm_em(name, identifier, 'div_for', "#{name}_po_element", &block)
      # _hooked_methods = gw_simple_sm(name, identifier, GWTabSet,'div_for', &block)
      define_method(name) do
        send("#{name}_element")
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").set(value)
      end

      define_method("#{name}_element") do
        begin
          return GWTabSet.new(send("#{name}_po_element"), name)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").set(value)
      end
    end

    def gw_tree_nav_panel(name, identifier, &block)
      _hooked_methods = gw_simple_sm(name, identifier, GWTreeNavPanel,'div_for', &block)
      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end
    end

    def gw_question_set(name, identifier, &block)
      # _hooked_methods = gw_simple_sm(name, identifier, GWQuestionSet,'div_for', &block)
      _hooked_methods = hooked_sm_em(name, identifier, 'div_for', "#{name}_po_element", &block)
      sel = { class: 'x-grid-row' }

      define_method("#{name}=") do |value|
        send("#{name}_element").set(value)
      end
      define_method(name) do
        send("#{name}_element")
      end

      define_method("#{name}_element") do
        begin
          return GWQuestionSet.new(send("#{name}_po_element"), sel, self)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end
    end

    def gw_form_set(name, identifier, &block)
      # _hooked_methods = gw_simple_sm(name, identifier, GWQuestionSet,'div_for', &block)
      _hooked_methods = hooked_sm_em(name, identifier, 'table_for', "#{name}_po_element", &block)
      sel = { class: 'x-field' }

      define_method("#{name}=") do |value|
        send("#{name}_element").set(value)
      end
      define_method(name) do
        send("#{name}_element")
      end

      define_method("#{name}_element") do
        begin
          return GWFormSet.new(send("#{name}_po_element"), sel, name, self)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end
    end

    def gw_simple_sm(name, identifier, control_class, method, &block)
      _hooked_methods = hooked_sm_em(name, identifier, method, "#{name}_po_element", &block)

      define_method(name) do
        send("#{name}_element")
      end

      define_method("#{name}_element") do
        begin
          return control_class.new(send("#{name}_po_element"))
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end
      _hooked_methods
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
