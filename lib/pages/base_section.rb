# frozen_string_literal: true

# Base class for all sections in the framework
class BaseSection
  include PageObject
  include DataMagic
  include PageFactory

  def populate(data = {}, additional = {})
    populate_page_with(data_for_or_default(self.class.to_s.snakecase, default_data, additional)) if data.nil? || data.empty?
    populate_page_with(data) unless data.nil? || data.empty?
  end

  def populate_value(receiver, key, value)
    return self.send("#{key}=", value) if self.respond_to?("#{key}=")

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
