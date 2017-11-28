# frozen_string_literal: true

require 'rspec/expectations'

# Custom matchers for RSpec to make working with web elements easier.
module RSpec
  # @!method match_href(pattern)
  # Matches if the href of a link matches a regular expression.
  # @param pattern [Regex] A regex that should match the href of the link.
  RSpec::Matchers.define :match_href do |expected|
    match do |actual|
      actual.href.match? expected
    end

    failure_message do |actual|
      "expected link href to match expression: #{expected} got: #{actual.href}"
    end
  end

  # @!method have_href(expected_url)
  # Matches if the href of a link exactly matches a string.
  # @param expected_url [String] A string that should match the href of the link.
  RSpec::Matchers.define :have_href do |expected|
    match do |actual|
      actual.href == expected
    end

    failure_message do |actual|
      "expected link href to be: #{expected} got: #{actual.href}"
    end
  end

  # @!method match_host(pattern)
  # Matches if the hostname of a link matches a regular expression.
  # @param pattern [Regex] A regex that should match the hostname of the link.
  RSpec::Matchers.define :match_host do |expected|
    match do |actual|
      actual.host.match? expected
    end

    failure_message do |actual|
      "expected link host to match expression: #{expected} got: #{actual.host}"
    end
  end

  # @!method have_host(expected_hostname)
  # Matches if the hostname of a link exactly matches a string.
  # @param expected_hostname [String] A string that should match the hostname of the link.
  RSpec::Matchers.define :have_host do |expected|
    match do |actual|
      actual.host == expected
    end

    failure_message do |actual|
      "expected link host to be: #{expected} got: #{actual.host}"
    end
  end

  # @!method have_protocol(expected_protocol)
  # Matches if the protocol of a link exactly matches a string.
  # @param expected_protocol [String] A string that should match the protocol of the link.
  RSpec::Matchers.define :have_host do |expected|
    match do |actual|
      actual.protocol == expected
    end

    failure_message do |actual|
      "expected link protocol to be: #{expected} got: #{actual.protocol}"
    end
  end

  # @!method have_path(expected_path)
  # Matches if the path of a link exactly matches a string.
  # @param expected_path [String] A string that should match the path of the link.
  RSpec::Matchers.define :have_path do |expected|
    match do |actual|
      actual.pathname == expected
    end

    failure_message do |actual|
      "expected link path to be: #{expected} got: #{actual.pathname}"
    end
  end

  # @!method match_path(pattern)
  # Matches if the path of a link matches a regex.
  # @param pattern [Regex] A pattern that should match the path of the link.
  RSpec::Matchers.define :match_path do |expected|
    match do |actual|
      actual.pathname.match?(expected)
    end

    failure_message do |actual|
      "expected link path to be: #{expected} got: #{actual.pathname}"
    end
  end
end
