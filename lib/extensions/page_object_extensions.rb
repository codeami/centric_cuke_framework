# frozen_string_literal: true

## PageObject namespace for monkey patching
module PageObject
  extend Forwardable
  def_delegators :root, :visible?, :present?, :exists?

  def change_page_using(element, opts = {})
    opts[:current_url] ||= @browser.url

    begin
      send(element.to_sym)
    rescue StandardError
      wait_for_ajax
      send(element.to_sym)
    end

    wait_for_url_change(opts)
  end

  def wait_for_ajax_using(facade, timeout = 120, message = nil)
    cur_facade = PageObject::JavascriptFrameworkFacade.framework
    PageObject::JavascriptFrameworkFacade.framework = facade
    _wait_for_ajax(timeout, message)
    PageObject::JavascriptFrameworkFacade.framework = cur_facade
  end

  def wait_for_url_change(opts)
    url_now = opts.fetch(:current_url, @browser.url)
    Watir::Wait.until { @browser.url != url_now }
    wait_for_ajax
    page = nil
    page = on_page(opts[:target_page].to_s.to_page_class) if opts[:target_page]
    opts[:factory].current_page = page if opts[:factory]
    page
  end

  def wait_for_ajax(timeout = 120, message = nil)
    return wait_for_ajax_using(page_facade_value, timeout, message) if respond_to? :page_facade_value

    _wait_for_ajax(timeout, message)
  end

  ##
  # :category: extensions
  #
  # Wait for ajax calls to complete
  # This differs from the stock wait_for_ajax in that it does not blow up while page navigation is occuring
  #
  def _wait_for_ajax(timeout = 120, message = nil)
    sleep 0.25 # Give the browser time to start it's ajax requests
    end_time = ::Time.now + timeout
    unknown_count = 0
    until ::Time.now > end_time
      begin
        pending = browser.execute_script(::PageObject::JavascriptFrameworkFacade.pending_requests)
      rescue Selenium::WebDriver::Error::UnknownError
        unknown_count += 1
        pending = unknown_count > 2 ? 0 : 1
      rescue Selenium::WebDriver::Error::NoSuchDriverError
        binding.pry
        pending = 0
      end

      return if pending.zero?

      sleep 0.5
    end
    raise message || 'Timed out waiting for ajax requests to complete'
  end

  def fresh_root
    @browser.element(root.element.instance_variable_get('@selector'))
  end

  ## PageObject::Accessors namespace for monkey patching
  module Accessors
    def select_list(name, identifier = { index: 0 }, &block)
      standard_methods(name, identifier, 'select_list_for', &block)
      define_method(name) do
        return platform.select_list_value_for identifier.clone unless block_given?

        send("#{name}_element").value
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").fire_event :click
        send("#{name}_element").select(value)
        send("#{name}_element").fire_event :blur
      end
      define_method("#{name}_options") do
        element = send("#{name}_element")
        element&.options ? element.options.collect(&:text) : []
      end
    end

    ##
    # :category: extensions
    #
    # Add a link field that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_button(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send(new_name.to_s)
      end
    end

    ##
    # :category: extensions
    #
    # Add a div field that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_div(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send(new_name.to_s)
      end
    end

    ##
    # :category: extensions
    #
    # Add a link field that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_link(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send(new_name.to_s)
      end
    end

    ##
    # :category: extensions
    #
    # Add a select list that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_select_list(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send(new_name.to_s)
      end
      define_method("#{name}=") do |value|
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}=", value)
      end
      define_method("#{name}_options") do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}_options")
      end
    end

    ##
    # :category: extensions
    #
    # Add a text field that has been renamed so that the user gets a warning to update their code with the new name
    #
    def depreciated_text_field(name, new_name)
      depreciated_standard_methods(name, new_name)
      define_method(name) do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}_element").value
      end
      define_method("#{name}=") do |value|
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}_element").value = value
      end
    end

    ##
    # :category: extensions
    #
    # This mimics the behavior of standard_methods for depricated fields.  This is called by depreciated_text_field
    #
    def depreciated_standard_methods(name, new_name)
      define_method("#{name}_element") do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}_element")
      end
      define_method("#{name}?") do
        warn "Deprecation warning: #{name} is now #{new_name} please update your code."
        send("#{new_name}?")
      end
    end

    def masked_text_field(name, identifier = { index: 0 }, &block)
      standard_methods(name, identifier, 'text_field_for', &block)
      define_method(name) do
        return platform.text_field_value_for identifier.clone unless block_given?

        send("#{name}_element").value
      end
      define_method("#{name}=") do |value|
        return platform.text_field_value_set(identifier.clone, value) unless block_given?

        send("#{name}_element").value = value
        send("#{name}_element").fire_event 'blur'
      end
    end
  end

  module Accessors
    def page_facade(facade)
      define_method('page_facade_value') do
        facade
      end
    end
  end

  module PageFactory
    attr_accessor :current_page
    def on_current_page(&block)
      yield @current_page if block
      @current_page
    end

    #
    # Create a page object.
    #
    # @param page_class [PageObject, String]  a class that has included the PageObject module or a string containing the name of the class
    # @param params [Hash] values that is pass through to page class a
    # available in the @params instance variable.
    # @param visit [Boolean]  a boolean indicating if the page should be visited?  default is false.
    # @param block [block]  an optional block to be called
    # @return [PageObject] the newly created page object
    #
    def on_page(page_class, params = { using_params: {} }, visit = false, &block)
      page_class = class_from_string(page_class) if page_class.is_a? String
      return super(page_class, params, visit, &block) unless page_class.ancestors.include? PageObject

      merged = page_class.params.merge(params[:using_params])
      page_class.instance_variable_set('@merged_params', merged) unless merged.empty?
      @current_page = page_class.new(@browser, visit)
      @current_page.wait_till_loaded if @current_page.respond_to?(:wait_till_loaded)
      block&.call @current_page
      @current_page
    end
  end

  module Javascript

    module ExtJs
      #
      # return the number of pending ajax requests
      #
      def self.pending_requests
        'return Ext.Ajax.isLoading() ? 1 : 0'
      end
    end
  end

  JavascriptFrameworkFacade.add_framework(:ext_js, ::PageObject::Javascript::ExtJs)
end
