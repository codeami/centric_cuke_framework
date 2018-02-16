# frozen_string_literal: true

# Extending String
class String
  # @return [String] A camelcase string representing a page class from the string.
  def to_page_class_name
    class_name = camelcase(:upper).delete(' ')
    /Page$/.match(class_name) ? class_name : "#{class_name}Page"
  end

  # @return [Object] A constant representing the page class from the string.
  def to_page_class
    Object.const_get to_page_class_name
  end
end
