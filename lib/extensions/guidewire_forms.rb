module PageObject
class GWFormText < GWQuestionSetQuestion
  attr_reader :question_type
  def initialize(element)
    super(element, :form_text)
  end

  def pry
    binding.pry;2
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

  def text
    label.text
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

class GWFormMultilineText < GWQuestionSetQuestion
  attr_reader :question_type
  def initialize(element)
    super(element, :form_text_multi)
  end

  def pry
    binding.pry;2
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

  def text
    label.text
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

class GWFormTextDisplay < GWQuestionSetQuestion
  attr_reader :question_type
  def initialize(element)
    super(element, :form_text_display)
  end

  def pry
    binding.pry;2
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
    element.divs(role: 'textbox').count == 1
  end

  def text
    label.text
  end

  private

  def display_div
    div(role: 'textbox')
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    retry
  end
end

GuideWire.question_types[:form_text_display] = GWFormTextDisplay

class GWFormActionableText < GWQuestionSetQuestion
  attr_reader :question_type
  def initialize(element)
    super(element, :actionable_text)
  end

  def pry
    binding.pry;2
    puts ''
  end

  def value
    ''
  end

  def answer
    value
  end

  def set(_val)
    # TODO: Implement
    raise "Not yet implemented"
  end

  def self.handle_element?(element)
    element.divs(role: 'textbox').count == 1
  end

  def text
    "#{label.text}#{display_div.text.delete(':')}"
  end

  private

  def display_div
    div(role: 'textbox')
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    retry
  end
end

GuideWire.question_types[:actionable_text] = GWFormActionableText

class GWFormSelectList < GWQuestionSetQuestion
  def initialize(element)
    super(element, :form_select_list)
  end

  def pry
    binding.pry;2
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

  def text
    label.text
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

class GWFormDate < GWQuestionSetQuestion
  def initialize(element)
    super(element, :form_date)
  end

  def pry
    binding.pry;2
    puts ''
  end

  def value
    Chronic.parse(editor.value)
  end

  def to_h
    { key =>  {text: text, value: editor.value } }
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

  def text
    label.text
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

class GWFormSearchableText < GWQuestionSetQuestion
  def initialize(element)
    super(element, :form_searchable_text)
  end

  def search
    # TODO: Implement
    raise 'Not implmented yet'
  end

  def pry
    binding.pry;2
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

  def text
    label.text
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
