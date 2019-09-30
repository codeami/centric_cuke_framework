# frozen_string_literal: true

module PageObject
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
      class_name.include? 'x-form-cb-checked'
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
      Watir::Wait.until { present? }
      tds(role: 'presentation').map { |b| GWRadioButton.new(b, @set_classname, @label_selector) }
    end

    def text
      selected_item&.text
    end
    alias value text

    def selected_item
      items.detect(&:set?)
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
      rescue Exception => e
        # rubocop:disable Lint/Debugger
        binding.pry if Nenv.cuke_debug?
        STDOUT.puts "#{e.message} getting items for form radio button array"
        # rubocop:enable Lint/Debugger
      end
    end

    def text
      selected_item&.text
    end
    alias value text

    def selected_item
      items.detect(&:set?)
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
    alias checked? set?
    alias check set

    def uncheck
      click if checked?
    end
  end
end
