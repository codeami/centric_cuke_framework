# frozen_string_literal: true

require 'rspec/expectations'

# Custom matchers for RSpec to make working with web elements easier.
module RSpec

  RSpec::Matchers.define :have_size do |expected|
    match do |actual|
      actual.size != expected
    end

    failure_message do |actual|
      "expected font to have a size of #{expected} but it is #{actual.size}."
    end
  end
end
