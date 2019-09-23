# frozen_string_literal: true

# Base class for all sections in the framework
class BaseSection
  include PageObject
  include DataMagic
  include PageFactory

  # populate the page with data, if data is not provided it will be pulled from data magic
  #
  def populate(data = {}, additional = {})
    populate_page_with(data_for_or_default(self.class.to_s.snakecase, default_data, additional)) if data.nil? || data.empty?
    populate_page_with(data) unless data.nil? || data.empty?
  end

  # Define populate_value so that if we define a key= method it gets called instead of PageObject barfing on us when we're
  # not dealing with something that's an element.
  def populate_value(receiver, key, value)
    return send("#{key}=", value) if respond_to?("#{key}=")

    populate_checkbox(receiver, key, value) if is_checkbox?(receiver, key) && is_enabled?(receiver, key)
    populate_radiobuttongroup(receiver, key, value) if is_radiobuttongroup?(receiver, key)
    populate_radiobutton(receiver, key, value) if is_radiobutton?(receiver, key) && is_enabled?(receiver, key)
    populate_select_list(receiver, key, value) if is_select_list?(receiver, key)
    populate_text(receiver, key, value) if is_text?(receiver, key) && is_enabled?(receiver, key)
  end

  # Base classes should override this to provide default data
  def default_data
    {}
  end
end
