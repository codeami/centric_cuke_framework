# frozen_string_literal: true

# Module for all helper classes and functions
module Helpers
  # Convert a cucumber table to a ruby hash
  def self.table_to_hash(table)
    table.transpose.raw.each_with_object({}) do |column, hash|
      column.reject!(&:empty?)
      hash[column.shift.to_sym] = column
    end
  end
end
