module PageObject
  class GWFormField < GWQuestionSetQuestion
    def locate_label
      return label unless label.text.empty?
      prev_row = tr(xpath: '(../../preceding-sibling::tr)[last()]')
      lbl = prev_row.labels.first
      while lbl.nil? || lbl.text.empty? do
        prev_row = prev_row.tr(xpath: '(../../preceding-sibling::tr)[last()]')
        lbl = prev_row.labels.first
      end
      lbl
    end

    def label_ele
      @label ||= locate_label
    end

    def text
      label_ele.text
    end
  end

  class GWFormText < GWFormField
    def initialize(element, sub_type = nil)
      super(element, sub_type || :form_text)
    end

    def pry
      binding.pry; 2
      puts ''
    end

    def value
      editor.value
    end

    def answer
      value
    end

    def set(val)
      editor.set(val)
    end

    def self.handle_element?(element)
      correct_input_count?(element) && !has_triggers?(element)
    end

    private

    def editor
      text_field(class: %w[x-form-field x-form-text])
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_input_count?(element)
      return element.text_fields(class: %w[x-form-field x-form-text]).count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_text] = GWFormText

  class GWFormMultilineText < GWFormText
    def initialize(element)
      super(element, :form_text_multi)
    end

    def pry
      binding.pry; 2
      puts ''
    end

    private

    def editor
      textarea(class: %w[x-form-field x-form-text])
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_input_count?(element)
      return element.textareas(class: %w[x-form-field x-form-text]).count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_text_multi] = GWFormMultilineText

  class GWFormTextDisplay < GWFormField
    def initialize(element)
      super(element, :form_text_display)
    end

    def pry
      binding.pry; 2
      puts ''
    end

    def value
      display_div.text
    end

    def answer
      value
    end

    def set(_val)
      STDERR.puts "Warning attempting to set a display only field"
    end

    def self.handle_element?(element)
      !element.class_name.include?('g-actionable') && element.divs(role: 'textbox').count == 1
    end

    private

    def display_div
      div(role: 'textbox')
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_text_display] = GWFormTextDisplay

  class GWFormActionableText < GWFormField
    attr_reader :question_type

    def initialize(element)
      super(element, :actionable_text)
    end

    def pry
      binding.pry; 2
      puts ''
    end

    def value
      display_div.text
    end

    def answer
      value
    end

    def set(_val)
      # TODO: Implement
      raise "Not yet implemented"
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

  class GWFormSelectList < GWFormField
    def initialize(element)
      super(element, :form_select_list)
    end

    def pry
      binding.pry; 2
      puts ''
    end

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
      @control ||= GWSelectList.new(div(class: 'x-form-item-body'))
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_input_count?(element)
      return element.text_fields(role: 'combobox').count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_select_list] = GWFormSelectList

  class GWFormDate < GWFormField
    def initialize(element)
      super(element, :form_date)
    end

    def pry
      binding.pry; 2
      puts ''
    end

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
      return element.text_fields(class: %w[x-form-field x-form-text]).count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_date] = GWFormDate

  class GWFormSearchableText < GWFormField
    def initialize(element)
      super(element, :form_searchable_text)
    end

    def search
      # TODO: Implement
      raise 'Not implmented yet'
    end

    def pry
      binding.pry; 2
      puts ''
    end

    def value
      editor.value
    end

    def answer
      value
    end

    def set(val)
      editor.set(value)
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
      return element.text_fields(class: %w[x-form-field x-form-text]).count == 1
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  GuideWire.question_types[:form_searchable_text] = GWFormSearchableText
end
