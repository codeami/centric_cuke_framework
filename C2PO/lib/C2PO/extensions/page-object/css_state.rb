def css_state(name, states)
  default_state = states.delete(:default) || :unknown

  # TODO: We should make the CSS matching part of element
  define_method("css_class_match?") do |class_names, matcher, invert = false|
    if matcher.is_a?(Hash)
      return css_class_match?(class_names, matcher.values.first, matcher.keys.first == :not)
    elsif matcher.is_a?(Regexp)
      val = class_names.match?(matcher)
    else
      val = class_names.include?(matcher)
    end

    invert ? !val : val
  end

  states.each { |k, v|
    define_method("#{name}_#{k}?") do
      css_class_match?(self.send("#{name}_element").element.class_name, v)
    end
  }

  unless states.key?(default_state)
    define_method("#{name}_#{default_state}?") do
      ele = self.send("#{name}_element").element
      !states.any?{ |_k, v| css_class_match?(ele.class_name, v) }
    end
  end

  define_method("#{name}_state") do
    ele = self.send("#{name}_element").element
    (key, _value) = states.find{ |_k, v| css_class_match?(ele.class_name, v) }
    key ||= default_state
    key
  end
end