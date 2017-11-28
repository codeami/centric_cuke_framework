# frozen_string_literal: true

require 'rspec/expectations'

# Custom matchers for RSpec to make working with web elements easier.
module RSpec
  # @!method have_class(expected_class)
  # Matches if the element has the expected CSS class as one of it's classes.
  # @param expected_class [String] The CSS class to look for.
  RSpec::Matchers.define :have_class do |expected|
    match do |actual|
      actual.class_name.split.include? expected
    end

    failure_message do |actual|
      "expected element to have the CSS class: #{expected} got: #{actual.class_name}"
    end
  end

  # @!method only_have_class(expected_class)
  # Matches if the element has the expected CSS class it's only class.
  # @param expected_class [String] The CSS class to look for.
  RSpec::Matchers.define :only_have_class do |expected|
    match do |actual|
      actual.class_name == expected
    end

    failure_message do |actual|
      "expected element to only have the CSS class: #{expected} got: #{actual.class_name}"
    end
  end

  # @!method have_classes(expected_classes)
  # Matches if the element has the expected CSS classes.
  # @param expected_classes [Array[String]] The CSS classes to look for.
  RSpec::Matchers.define :have_classes do |expected|
    match do |actual|
      classes = actual.class_name.split
      expected.all? { |e| classes.include?(e) }
    end

    failure_message do |actual|
      "expected element to have the CSS classes: #{expected} got: #{actual.class_name}"
    end
  end

  # @!method only_have_classes(expected_classes)
  # Matches if the element has the expected CSS classes and no others regardless of order.
  # @param expected_classes [Array[String]] The CSS classes to look for
  RSpec::Matchers.define :only_have_classes do |expected|
    match do |actual|
      actual.class_name.split.sort == expected.sort
    end

    failure_message do |actual|
      "expected element to have only the CSS classes: #{expected} got: #{actual.class_name}"
    end
  end

  # @!method only_have_classes(expected_classes)
  # Matches if the element has the expected CSS classes and no others regardless of order.
  # @param expected_classes [Array[String]] The CSS classes to look for
  RSpec::Matchers.define :only_have_exact_classes do |expected|
    match do |actual|
      actual.class_name.split == expected
    end

    failure_message do |actual|
      "expected element to have only the CSS classes: #{expected} in that order got: #{actual.class_name}"
    end
  end
end
