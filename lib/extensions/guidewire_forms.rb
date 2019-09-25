# frozen_string_literal: true

require 'chronic'

module PageObject
  # This handles sets of form fields within a table layout.
  #
  # It will parse each row of the table and add the appropriate methods to manipulate them.
  # Much like the QuestionSet does. This is the primary consumer of the various form classes.
  #
  # This is not currently safe for use at WRG
  #
  class GWFormSet < GWQuestionSet
    # Newness
    def initialize(element, row_selector, name, parent)
      super(element, row_selector, parent)
      @name = name
    end

    # Internal helper function
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

  # A GWFormset within a tab
  class GWFormsetTab < GWFormSet
    def initialize(element, name)
      super(element, { class: 'x-field', visible: true }, name)
    end
  end

  # Models a set of tabs
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

    # Returns all of the tab elements
    def tabs
      @tabs ||= Hash[*tab_links.map { |l| { l.text.strip.snakecase => l } }.collect(&:to_a).flatten]
    end

    # Return the text of all tabs
    def tabs_text
      tab_links.map(&:text)
    end

    # Returns the internal IDs of the tabs
    def tab_keys
      tab_links.map { |l| l.text.snakecase }
    end

    # Return either an instance of a specific class or a generic GWFormsetTab for the currently displayed tab
    def active_tab
      class_name = Object.const_defined?(classname_for_tab) ? Object.const_get(classname_for_tab) : GWFormsetTab
      class_name.new(div(class: 'x-tabpanel-child', visible: true), active_tab_text)
    end

    # Returns the class name for the currently displayed tab.
    def classname_for_tab
      "#{@name}#{active_tab_text}".delete(' &:,').camelcase(:upper)
    end

    # Returns the text of the active tab
    def active_tab_text
      active_tab_link.text
    end

    # Returns the number of tabs present
    def tab_count
      tab_links.count
    end

    # Returns an array of link objects for the tabs
    def tab_links
      @tab_links ||= links(class: 'x-tab')
    end

    # Returns a link object for the current tab
    def active_tab_link
      link(class: 'x-tab-active')
    end
  end

  # Base class for all from fields
  class GWFormField < GWQuestionSetQuestion

    # Internal helper function
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

    # Internal helper function
    def label_ele
      @label_ele ||= locate_label
    end

    # Returns the label text
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

  # A textfield with changeto functionality
  class GWFormChangeTo < GWFormField
    # newness
    def initialize(element)
      super(element, :form_text_display)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    # This has no value
    def value
      ''
    end

    # returns the text
    def text
      "change #{super} to"
    end

    # alias
    def answer
      value
    end

    # Set the value
    def set(val)
      raise 'Not implemented' unless val.to_s.empty?
    end

    # Internal helper function
    def self.handle_element?(element)
      element.links(class: 'g-actionable').count == 1 && element.divs(role: 'textbox').count == 1
    end

    private

    # Internal helper function
    def display_div
      div(role: 'textbox')
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_change_to] = GWFormChangeTo

  # A select list
  class GWFormSelectList < GWFormField
    # yay
    def initialize(element)
      super(element, :form_select_list)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    # Return the value of the control
    def value
      control.value
    end

    # alias for value
    def answer
      value
    end

    # set the value by selecting it from the list
    def set(val)
      control.select_item(val)
    end

    # Internal helper function
    def self.handle_element?(element)
      correct_input_count?(element)
    end

    private

    # Internal helper function
    def control
      @control ||= GWSelectList.new(self) # class: 'x-form-item-body'))
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    # Internal helper function
    def self.correct_input_count?(element)
      element.text_fields(role: 'combobox').count == 1 &&
        element.divs(class: 'x-form-arrow-trigger', visible: true).count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_select_list] = GWFormSelectList

  # A date input
  class GWFormDate < GWFormField
    # Newness
    def initialize(element)
      super(element, :form_date)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    # Return the value as a date
    def value
      Chronic.parse(editor.value)
    end

    # Customize to_h so that it uses the text from the editor
    def to_h
      { key => { text: text, value: editor.value } }
    end

    # alias for value
    def answer
      value
    end

    # Set the value using a string that Chronic can parse or something that responds to strftime
    def set(val)
      date = val.is_a?(string)? Chronic.parse(val) : val
      editor.set(date.strftime('%m/%d/%Y'))
    end

    # Internal helper function
    def self.handle_element?(element)
      correct_input_count?(element) && element.divs(class: 'x-form-date-trigger').count.positive?
    end

    private

    # Internal helper function
    def editor
      text_field(class: %w[x-form-field x-form-text])
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    # Internal helper function
    def self.correct_input_count?(element)
      element.text_fields(class: %w[x-form-field x-form-text]).count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_date] = GWFormDate

  # A checkbox within a header
  class GWFormFieldsetHeaderCheck < GWFormField
    # Newnewss
    def initialize(element, sub_type = nil)
      super(element, sub_type || :form_fieldset_header_check)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    # Return the value
    def value
      _checkbox.class_name.include? 'x-form-cb-checked'
    end

    # Alias for value
    def answer
      value
    end

    # Set the value unless already set
    def set(val)
      click unless value == val
    end

    # Internal helper function
    def self.handle_element?(element)
      element.class_name.include? 'x-fieldset-header-checkbox'
    end

    # Internal helper function
    def label_ele
      div(xpath: './following-sibling::div')
    end

    private

    # Internal helper function
    def _checkbox
      button(role: 'checkbox')
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    # Internal helper function
    def self.correct_input_count?(element)
      element.text_fields(class: %w[x-form-field x-form-text]).count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_fieldset_header_check] = GWFormFieldsetHeaderCheck

  # A radioset within a form
  class GWFormRadioSet < GWFormField
    # Newness
    def initialize(element)
      super(element, :radio_set)
    end

    # Internal helper function
    def label_ele
      label(xpath: '../../../../..//label')
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    # Get the value from the radio button array
    def value
      array.value
    end

    # alias for value
    def answer
      value
    end

    # Set the value
    def set(val)
      array.set(val)
    end

    # Internal helper function
    def self.handle_element?(element)
      correct_input_count?(element)
    end

    private

    # Internal helper function
    def array
      @array ||= GWFormRadioButtonArray.new(div(index: 0))
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      @arry = nil
      retry
    end

    # Internal helper function
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
