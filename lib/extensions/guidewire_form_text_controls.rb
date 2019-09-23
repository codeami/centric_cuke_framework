# frozen_string_literal: true

module PageObject

  # Handles a row with a single text field
  class GWFormText < GWFormField
    def initialize(element, sub_type = nil)
      super(element, sub_type || :form_text)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    def value
      editor.value
    end

    def answer
      value
    end

    def set(val)
      editor.set(val)
      editor.send_keys(:tab)
    end

    def self.handle_element?(element)
      correct_input_count?(element) # && !has_triggers?(element)
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

  # Handles rows that contain a single auto-filled text field
  class GWFormAutoFillText < GWFormText
    def initialize(element)
      super(element, :form_autofill_text)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    def self.handle_element?(element)
      correct_input_count?(element)
    end

    def set(val)
      editor.click
      editor.set(val)
      editor.send_keys(:tab)
    end

    private

    def editor
      text_field(class: %w[x-form-field x-form-text])
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_input_count?(element)
      element.text_fields(class: %w[x-form-field x-form-text]).count == 1 &&
        element.images(src: /autofill/).count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_autofill_text] = GWFormAutoFillText

  # Handles rows that contain a single checkbox
  class GWFormCheckButton < GWFormField
    def initialize(element)
      super(element, :form_check_buttom)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    def value
      false
    end

    def answer
      false
    end

    def set(_val)
      check.click
    end

    def self.handle_element?(element)
      correct_input_count?(element)
    end

    private

    def check
      button(index: 0) # TODO: Figure out why we can't see the styles here
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_input_count?(element)
      element.buttons.count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_check_buttom] = GWFormCheckButton

  # Handles rows that contain a single multi-line textbox.
  class GWFormMultilineText < GWFormText
    def initialize(element)
      super(element, :form_text_multi)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    private

    def editor
      textarea(class: %w[x-form-field x-form-text])
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_input_count?(element)
      element.textareas(class: %w[x-form-field x-form-text]).count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_text_multi] = GWFormMultilineText

  # Handles the special case of a display only text field.
  # This mainly exists to prevent triggering the unknown question type logic
  class GWFormTextDisplay < GWFormField
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
      display_div.text
    end

    def answer
      value
    end

    def set(val)
      warn 'Warning attempting to set a display only field' unless val.empty?
    end

    def self.handle_element?(element)
      !element.class_name.include?('g-actionable') && element.divs(role: 'textbox').count == 1 && element.links.count.zero?
    end

    private

    def display_div
      div(role: 'textbox')
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_text_display] = GWFormTextDisplay

  # Handles the rows with have a text field and some sort of actionable button.
  class GWFormActionableText < GWFormField
    attr_reader :question_type

    def initialize(element)
      super(element, :actionable_text)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    def value
      display_div.text
    end

    def answer
      value
    end

    def set(_val)
      # TODO: Implement
      raise 'Not yet implemented' unless _val.to_s.empty?
    end

    def self.handle_element?(element)
      element.class_name.include?('g-actionable')
    end

    private

    def display_div
      div(class: 'x-form-item-body')
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:actionable_text] = GWFormActionableText

  # Handles rows which have a single text field that allows for searching
  class GWFormSearchableText < GWFormField
    def initialize(element)
      super(element, :form_searchable_text)
    end

    def search
      # TODO: Implement
      raise 'Not implmented yet'
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    def value
      editor.value
    end

    def answer
      value
    end

    def set(val)
      editor.click
      editor.set(val)
      editor.send_keys :tab
    end

    def self.handle_element?(element)
      correct_input_count?(element) && element.divs(class: 'x-form-search-trigger').count.positive?
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

  GuideWire.question_types[:form_searchable_text] = GWFormSearchableText
end
