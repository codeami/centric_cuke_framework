# frozen_string_literal: true

require 'page-object/accessors'
module PageObject
  #
  # Contains the class level methods that are inserted into your page objects
  # when you include the PageObject module.  These methods will generate another
  # set of methods that provide access to the elements on the web pages.
  #
  module Accessors
    # TODO: We should make the CSS matching part of element

    def _define_default_state(name, states, default_state)
      return if states.key?(default_state)
      define_method("#{name}_#{default_state}?") do
        ele = send("#{name}_element")
        states.none? { |_k, v| ele.css_class_match?(v) }
      end
    end

    def _define_state_fns(name, states)
      states.each do |k, v|
        define_method("#{name}_#{k}?") do
          send("#{name}_element").css_class_match?(v)
        end
      end
    end

    def css_state(name, states)
      default_state = states.delete(:default) || :unknown
      _define_state_fns(name, states)
      _define_default_state(name, states, default_state)

      define_method("#{name}_state") do
        ele = send("#{name}_element")
        (key, _value) = states.find { |_k, v| ele.css_class_match?(v) }
        key ||= default_state
        key
      end
    end
  end
end

module Watir
  class Element
    def css_class_match?(matcher, invert = false)
      return css_class_match?(matcher.values.first, matcher.keys.first == :not) if matcher.is_a?(Hash)
      method = matcher.is_a?(Regexp) ? :match? : include?
      val = class_name.send(method, matcher)
      invert ? !val : val
    end
  end
end
