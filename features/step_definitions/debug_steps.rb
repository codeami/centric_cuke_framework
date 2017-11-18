# frozen_string_literal: true

Given(/I trigger Pry/) do
  binding.pry_if(true)
  puts 'Oblig extra line for pry'
end
