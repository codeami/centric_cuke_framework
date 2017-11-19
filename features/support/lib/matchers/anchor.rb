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
  end

  # @!method have_href(expected_url)
  # Matches if the href of a link exactly matches a string.
  # @param expected_url [String] A string that should match the href of the link.
  RSpec::Matchers.define :have_href do |expected|
    match do |actual|
      actual.href == expected
    end
  end

  # @!method match_host(pattern)
  # Matches if the hostname of a link matches a regular expression.
  # @param pattern [Regex] A regex that should match the hostname of the link.
  RSpec::Matchers.define :match_host do |expected|
    match do |actual|
      actual.host.match? expected
    end
  end

  # @!method have_host(expected_hostname)
  # Matches if the hostname of a link exactly matches a string.
  # @param expected_hostname [String] A string that should match the hostname of the link.
  RSpec::Matchers.define :have_host do |expected|
    match do |actual|
      actual.host == expected
    end
  end
end
