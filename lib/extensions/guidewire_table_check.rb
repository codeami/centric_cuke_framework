# frozen_string_literal: true

module PageObject
  class GuidewireTableCheck < SimpleDelegator
    def set?
      class_name.include? 'x-form-cb-checked'
    end

    def checked?
      set?
    end

    def check
      click unless set?
    end

    def uncheck
      click if set?
    end

    def set(val)
      click unless val == set?
    end
  end

  module Accessors
    def gw_table_check(name, identifier, &block)
      _hooked_methods = hooked_sm_em(name, identifier, 'table_for', "#{name}_po_element", &block)

      define_method("#{name}_element") do
        begin
          return GuidewireTableCheck.new(send("#{name}_po_element"))
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          attempts ||= 0
    attempts += 1
    binding.pry if Nenv.cuke_debug?
    retry unless attempts > 3
        end
      end

      define_method(name) do
        send("#{name}_element").set?
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").set(value)
      end
    end
  end
end
