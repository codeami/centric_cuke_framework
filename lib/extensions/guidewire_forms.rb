# frozen_string_literal: true

require 'chronic'

module PageObject
  class GWFormSet < GWQuestionSet
    def initialize(element, row_selector, name, parent)
      super(element, row_selector, parent)
      @name = name
    end

    def _questions
      # divs( @row_selector).map { |r| class_for_row(r) }
      trs(role: 'presentation').map { |r| class_for_row(r) }.delete_if(&:nil?)
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      # rubocop:disable Lint/Debugger
      binding.pry if Nenv.debug?
      STDOUT.puts 'Line for pry' if Nenv.debug?
      # rubocop:enable  Lint/Debugger
      retry
    end

    def name
      @name.to_s
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger
  end

  class GWFormsetTab < GWFormSet
    def initialize(element, name)
      super(element, { class: 'x-field', visible: true }, name)
    end
  end

  class GWTabSet < SimpleDelegator
    def initialize(element, name)
      super(element)
      @name = name
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    def tabs
      @tabs ||= Hash[*tab_links.map { |l| { l.text.strip.snakecase => l } }.collect(&:to_a).flatten]
    end

    def tabs_text
      tab_links.map(&:text)
    end

    def tab_keys
      tab_links.map { |l| l.text.snakecase }
    end

    def active_tab
      class_name = Object.const_defined?(classname_for_tab) ? Object.const_get(classname_for_tab) : GWFormsetTab
      class_name.new(div(class: 'x-tabpanel-child', visible: true), active_tab_text)
    end

    def classname_for_tab
      "#{@name}#{active_tab_text}".delete(' &:,').camelcase(:upper)
    end

    def active_tab_text
      active_tab_link.text
    end

    def tab_count
      tab_links.count
    end

    def tab_links
      @tab_links ||= links(class: 'x-tab')
    end

    def active_tab_link
      link(class: 'x-tab-active')
    end
  end

  class GWFormField < GWQuestionSetQuestion
    def locate_label
      return label unless label.text.empty?

      prev_row = tr(xpath: '(../../preceding-sibling::tr)[last()]')
      lbl = prev_row.labels.first
      while lbl.nil? || lbl.text.empty?
        prev_row = prev_row.tr(xpath: '(../../preceding-sibling::tr)[last()]')
        lbl = prev_row.labels.first
      end
      lbl
    end

    def label_ele
      @label_ele ||= locate_label
    end

    def text
      label_ele.text
    rescue Exception => e
      # rubocop:disable Lint/Debugger
      binding.pry if Nenv.debug?
      STDOUT.puts 'Line for pry' if Nenv.debug?
      # rubocop:enable  Lint/Debugger
    end
  end

  require 'lib/extensions/guidewire_form_text_controls'

  class GWFormChangeTo < GWFormField
    def initialize(element)
      super(element, :form_text_display)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    def value
      ''
    end

    def text
      "change #{super} to"
    end

    def answer
      value
    end

    def set(val)
      raise 'Not implemented' unless val.to_s.empty?
    end

    def self.handle_element?(element)
      element.links(class: 'g-actionable').count == 1 && element.divs(role: 'textbox').count == 1
    end

    private

    def display_div
      div(role: 'textbox')
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_change_to] = GWFormChangeTo

  class GWFormSelectList < GWFormField
    def initialize(element)
      super(element, :form_select_list)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    def value
      control.value
    end

    def answer
      value
    end

    def set(val)
      control.select_item(val)
    end

    def self.handle_element?(element)
      correct_input_count?(element)
    end

    private

    def control
      @control ||= GWSelectList.new(self) # class: 'x-form-item-body'))
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_input_count?(element)
      element.text_fields(role: 'combobox').count == 1 &&
        element.divs(class: 'x-form-arrow-trigger', visible: true).count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_select_list] = GWFormSelectList

  class GWFormDate < GWFormField
    def initialize(element)
      super(element, :form_date)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    def value
      Chronic.parse(editor.value)
    end

    def to_h
      { key => { text: text, value: editor.value } }
    end

    def answer
      value
    end

    def set(val)
      date = Chronic.parse(val)
      editor.set(date.strftime('%m/%d/%Y'))
    end

    def self.handle_element?(element)
      correct_input_count?(element) && element.divs(class: 'x-form-date-trigger').count.positive?
    end

    private

    def editor
      text_field(class: %w[x-form-field x-form-text])
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_input_count?(element)
      element.text_fields(class: %w[x-form-field x-form-text]).count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_date] = GWFormDate

  class GWFormFieldsetHeaderCheck < GWFormField
    def initialize(element, sub_type = nil)
      super(element, sub_type || :form_fieldset_header_check)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    def value
      _checkbox.class_name.include? 'x-form-cb-checked'
    end

    def answer
      value
    end

    def set(val)
      click unless value == val
    end

    def self.handle_element?(element)
      element.class_name.include? 'x-fieldset-header-checkbox'
    end

    def label_ele
      div(xpath: './following-sibling::div')
    end

    private

    def _checkbox
      button(role: 'checkbox')
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_input_count?(element)
      element.text_fields(class: %w[x-form-field x-form-text]).count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_fieldset_header_check] = GWFormFieldsetHeaderCheck

  class GWFormRadioSet < GWFormField
    def initialize(element)
      super(element, :radio_set)
    end

    def label_ele
      label(xpath: '../../../../..//label')
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    def value
      array.value
    end

    def answer
      value
    end

    def set(val)
      array.set(val)
    end

    def self.handle_element?(element)
      correct_input_count?(element)
    end

    private

    def array
      @array ||= GWFormRadioButtonArray.new(div(index: 0))
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      @arry = nil
      retry
    end

    def self.correct_input_count?(element)
      element.buttons(role: 'radio').count > 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:radio_set] = GWFormRadioSet

  # This is listed last as a catchall
  GuideWire.question_types[:form_text] = GWFormText
end
