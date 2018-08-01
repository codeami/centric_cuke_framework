# frozen_string_literal: true

class String
  # Covert a string to a page class name
  #   Examples: 'foo' becomes FooPage
  #             'login_page' becomes LoginPage
  #
  # :category: extensions
  def to_page_class_name
    res = camelcase(:upper).delete(' ')
    res = "#{res}Page" unless res =~ /Page$/
    res
  end

  # Convert a string containing a page class name to it's constant
  def to_page_class
    Object.const_get to_page_class_name
  end
end
