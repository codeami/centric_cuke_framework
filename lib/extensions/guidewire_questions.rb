# frozen_string_literal: true

module PageObject
  class GWQuestionSetQuestion < SimpleDelegator
    attr_reader :question_type
    def initialize(element, question_type)
      super(element)
      @question_type = question_type
    end

    def key
      @key ||= "#{text.snakecase.gsub(/[^\w\d\s_]/, '')}_#{question_type}" # .to_sym
    end

    def text
      td.text
    end

    def to_h
      { key => { text: text, value: value } }
    end

    def self.has_triggers?(element)
      element.divs(class: 'x-form-trigger').count.positive?
    end

    def self.actionable?(element)
      element.links(class: 'g-actionable').count.positive?
    end
  end

  class GWQuestionSetYNQuestion < GWQuestionSetQuestion
    attr_reader :question_type
    def initialize(element)
      super(element, :yes_no)
      @label_sel = { class: 'x-form-cb-label' }
      @set_class = 'x-form-cb-checked'
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

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
      @answers ||= GWRadioButtonArray.new(table(class: 'gw-radio-group-cell'), @set_class, @label_sel)
    end

    def self.handle_element?(element)
      return false unless correct_input_count?(element)
      return false unless correct_labels?(element)

      true
    end

    def self.correct_input_count?(element)
      element.inputs(class: 'x-form-radio').count == 2
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_labels?(element)
      element.labels.map(&:text).join == 'YesNo'
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end
  end

  class GWFormYNQuestion < GWQuestionSetQuestion
    attr_reader :question_type
    def initialize(element)
      super(element, :yes_no)
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

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
      @answers ||= GWFormRadioButtonArray.new(div(index: 0))
    end

    def self.handle_element?(element)
      return false unless correct_input_count?(element)
      return false unless correct_labels?(element)

      true
    end

    def self.correct_input_count?(element)
      element.inputs(class: 'x-form-radio').count == 2
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_labels?(element)
      element.labels.map(&:text).join == 'YesNo'
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

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

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
      element.inputs(class: 'x-form-radio').count.zero?
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def self.correct_style?(element)
      element.tds(class: 'g-cell-edit').count == 1
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
      q = questions.detect { |d| d.key == key.to_s }
      return q if q

      @questions = nil
      q = questions.detect { |d| d.key == key.to_s }
      raise "Could not find a question matching #{key}" unless q

      q
    end

    def to_h
      Hash[*questions.map(&:to_h).collect(&:to_a).flatten]
    end

    def values
      vals = to_h.map { |k, v| { k => v[:value] } }
      { key => Hash[*vals.collect(&:to_a).flatten] }
    end

    def fixture_values
      STDOUT.puts YAML.dump(values)
    end

    def name
      td.text
    end

    def key
      @key ||= name.snakecase.gsub(/[^\w\d\s_]/, '')
    end

    # rubocop:disable Lint/Debugger
    def pry
      binding.pry
      STDOUT.puts 'Line for pry' if Nenv.debug?
    end
    # rubocop:enable Lint/Debugger

    def _questions
      trs(@row_selector).map { |r| class_for_row(r) }.delete_if(&:nil?)
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    end

    def questions
      @questions ||= _questions
    end

    def class_for_row(row)
      return nil unless row.tds.count > 1 && row.labels(visible: true).count.positive?

      q_class = GuideWire.question_types.values.detect { |q| q.handle_element?(row) }
      # rubocop:disable Lint/Debugger
      binding.pry unless q_class && Nenv.debug?
      # rubocop:enable Lint/Debugger
      warn 'Unknown question type' unless q_class
      q_class&.new(row)
    end
  end
end
