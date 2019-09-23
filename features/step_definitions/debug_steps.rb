# frozen_string_literal: true

Given(/I trigger Pry/) do
  # rubocop:disable Lint/Debugger
  binding.pry
  STDOUT.puts 'Line for pry' if Nenv.debug?
  # rubocop:enable Lint/Debugger
end
