# frozen_string_literal: true

module PageObject
  # Contains the class level methods that are inserted into your page objects
  # when you include the PageObject module.  These methods will generate another
  # set of methods that provide access to the elements on the web pages.
  #
  module Accessors

    # Add a Guidewire dropdown to your model. This custom element knows how to deal with the drop downs
    #
    #  This accessor accepts hooks
    def gw_dropdown(name, identifier, &block)
      list_sel = identifier.delete(:list) || { xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-boundlist-floating')]" }
      item_sel = identifier.delete(:items) || { class: 'x-boundlist-item' }
      _hooked_methods = hooked_sm_em(name, identifier, 'link_for', "#{name}_po_element", &block)

      define_method("#{name}_element") do
        begin
          return GWDropdown.new(send("#{name}_po_element"), list_sel, item_sel)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          # rubocop:disable Lint/Debugger
          binding.pry if Nenv.debug?
          STDOUT.puts 'Line for pry' if Nenv.debug?
          # rubocop:enable  Lint/Debugger
          retry
        end
      end

      define_method(name) do
        send("#{name}_element").text
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end
    end

    # Add a Guidewire dropdown to your model (Variant for dropdowns inside forms). This custom element knows how to deal with the drop downs
    #
    #  This accessor accepts hooks
    def gw_form_dropdown(name, identifier, &block)
      list_sel = identifier.delete(:list) || { xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-boundlist-floating')]" }
      item_sel = identifier.delete(:items) || { class: 'x-boundlist-item' }
      _hooked_methods = hooked_sm_em(name, identifier, 'div_for', "#{name}_po_element", &block)

      define_method("#{name}_element") do
        begin
          return GWDropdown.new(send("#{name}_po_element"), list_sel, item_sel)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end

      define_method(name) do
        send("#{name}_element").input.value
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end
    end

    # Add a Guidewire dropdown to your model (Variant for drop downs inside cells). This custom element knows how to deal with the drop downs
    #
    #  This accessor accepts hooks
    def gw_dropdown_cell(name, identifier, &block)
      list_sel = identifier.delete(:list) || { xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-boundlist-floating')]" }
      item_sel = identifier.delete(:items) || { class: 'x-boundlist-item' }
      _hooked_methods = hooked_sm_em(name, identifier, 'div_for', "#{name}_po_element", &block)

      define_method("#{name}_element") do
        begin
          return GWDropdownCell.new(send("#{name}_po_element"), list_sel, item_sel)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end

      define_method(name) do
        send("#{name}_element")
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end
    end


    # Add one of the floating lists to your model.  These are the things that show up for menus and select lists
    #
    # This accessor accepts hooks
    def gw_bound_list_floating(name, identifier, &block)
      item_sel = identifier.delete(:items) || { class: 'x-boundlist-item' }
      _hooked_methods = hooked_sm_em(name, identifier, 'div_for', "#{name}_po_element", &block)

      define_method("#{name}_element") do
        begin
          return GWBoundListFloating.new(send("#{name}_po_element"), item_sel)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end

      define_method(name) do
        send("#{name}_element")
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end
    end

    # Add an array of radio buttons to your model
    #
    # The identifier for this should be the for the div that contains all the radios.
    # This accessor accepts hooks
    def gw_radio_array(name, identifier, &block)
      label_sel = identifier.delete(:label) || { class: 'x-form-cb-label' }
      set_class = identifier.delete(:set_class) || 'x-form-cb-checked'
      _hooked_methods = hooked_sm_em(name, identifier, 'div_for', "#{name}_po_element", &block)

      define_method("#{name}_element") do
        begin
          return GWRadioButtonArray.new(send("#{name}_po_element"), set_class, label_sel)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end

      define_method(name) do
        send("#{name}_element").selected_item&.text
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select(value)
      end
    end

    # Add a grid to your model
    #
    # The identifier for this should be the for the div that contains all the grid and it's controls.
    # This accessor accepts hooks
    def grid_view(name, item_class, identifier, &block)
      item_sel = identifier.delete(:item_sel) || { class: 'x-grid-data-row' }
      _hooked_methods = hooked_standard_methods(name, identifier, 'div_for', &block)

      define_method(name) do
        begin
          return GridView.new(send("#{name}_element"), item_class, item_sel, self)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end
    end

    # Add a select list to your model
    #
    # The identifier for this should be the for the div that contains all the controls
    # This accessor accepts hooks
    def gw_select_list(name, identifier = { index: 0 }, &block)
      _hooked_methods = gw_simple_sm(name, identifier, GWSelectList, 'div_for', &block)
      define_method(name) do
        send("#{name}_element").value
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end
    end

    # Add a select list to your model (table variant)
    #
    # The identifier for this should be the for the table that contains all the controls
    # This accessor accepts hooks
    def gw_table_select_list(name, identifier = { index: 0 }, &block)
      _hooked_methods = gw_simple_sm(name, identifier, GWSelectList, 'table_for', &block)
      define_method(name) do
        send("#{name}_element").value
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end
    end

    # Add a tab controls to your model
    #
    # The identifier for this should be the for the div that contains all the tabs
    # This accessor accepts hooks
    def gw_tab_set(name, identifier, &block)
      _hooked_methods = hooked_sm_em(name, identifier, 'div_for', "#{name}_po_element", &block)
      define_method(name) do
        send("#{name}_element")
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").set(value)
      end

      define_method("#{name}_element") do
        begin
          return GWTabSet.new(send("#{name}_po_element"), name)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").set(value)
      end
    end

    # Add support for one of the tree navigation controls to your model
    #
    # The identifier for this should be the for the div that contains the entire tree
    # This accessor accepts hooks
    def gw_tree_nav_panel(name, identifier, &block)
      _hooked_methods = gw_simple_sm(name, identifier, GWTreeNavPanel, 'div_for', &block)
      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end
    end

    # Define a set of questions, using only the parent div
    #
    # The identifier for this should be the for the div that contains the questions
    # Note: This is not yet safe for use at WRG
    # This accessor accepts hooks
    def gw_question_set(name, identifier, &block)
      _hooked_methods = hooked_sm_em(name, identifier, 'div_for', "#{name}_po_element", &block)
      sel = { class: 'x-grid-row' }

      define_method("#{name}=") do |value|
        send("#{name}_element").set(value)
      end
      define_method(name) do
        send("#{name}_element")
      end

      define_method("#{name}_element") do
        begin
          return GWQuestionSet.new(send("#{name}_po_element"), sel, self)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end
    end

    # Define a form with multiple fields, using only the parent div
    #
    # The identifier for this should be the for the div that contains the form
    # Note: This is not yet safe for use at WRG
    # This accessor accepts hooks
    def gw_form_set(name, identifier, &block)
      # _hooked_methods = gw_simple_sm(name, identifier, GWQuestionSet,'div_for', &block)
      _hooked_methods = hooked_sm_em(name, identifier, 'table_for', "#{name}_po_element", &block)
      sel = { class: 'x-field' }

      define_method("#{name}=") do |value|
        send("#{name}_element").set(value)
      end
      define_method(name) do
        send("#{name}_element")
      end

      define_method("#{name}_element") do
        begin
          return GWFormSet.new(send("#{name}_po_element"), sel, name, self)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end
    end

    # Internal helper function to add common methods for the various custom elements
    def gw_simple_sm(name, identifier, control_class, method, &block)
      _hooked_methods = hooked_sm_em(name, identifier, method, "#{name}_po_element", &block)

      define_method(name) do
        send("#{name}_element")
      end

      define_method("#{name}_element") do
        begin
          return control_class.new(send("#{name}_po_element"))
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end
      _hooked_methods
    end

    # TODO: This is a TERRIBLE name
    # For text fields which cause other fields to show up
    def revealing_text_field(name, finder_method, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'text_field_for', &block)
      define_method(name) do
        return platform.text_field_value_for identifier.clone unless block_given? || hooked_methods.include?(:value)

        send("#{name}_element").value
      end
      define_method("#{name}=") do |value|
        ele = send("#{name}_element")
        ele.value = value
        ele.send_keys :tab
        Watir::Wait.until { finder_method.is_a?(Proc) ? finder_method.call : send(finder_method) }
      end
    end
  end
end
