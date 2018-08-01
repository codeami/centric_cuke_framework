# frozen_string_literal: true

Given(/I trigger Pry/) do
  binding.pry
  puts 'Oblig extra line for pry'
end
