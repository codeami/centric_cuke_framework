# frozen_string_literal: true

# Extensions to the integer class
class Integer
  # @return [string] A date string X number of months from now
  def months_from_today(format = '%D')
    the_day = Date.today >> self
    the_day.strftime(format)
  end

  # @return [string] A date string X number of months from ago
  def months_ago(format = '%D')
    the_day = Date.today << self
    the_day.strftime(format)
  end
end
