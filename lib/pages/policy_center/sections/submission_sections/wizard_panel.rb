# frozen_string_literal: true

require_relative 'wizard_detail_panels'

# This class abstracts the submission wizard.
# It will create specialized detail panels to handle the various steps along the path.
# These detail panels must follow the naming convention of using the title of the step
# as the name of the class plus WizardDetailPanel.  i.e. "Offerings" becomes OfferingsWizardDetailPanel
# if the title of the step includes things like (1 of 3) they will be removed
#
# Be sure to read the documentation for populate_to.
#
class WizardPanel < BasePage
  span(:title, class: 'g-title')
  link(:next_button, id: 'SubmissionWizard:Next')
  link(:prev_button, id: 'SubmissionWizard:Prev')
  link(:quote, text: 'Quote')
  link(:save_draft, text: 'Save Draft')
  gw_dropdown(:close_options, text: 'Close Options')

  # The ket to be used for pulling data from data magic
  #
  # Useful for base classes to override.
  def data_for_key
    :wizard_panel
  end

  # Returns a string representing the class name that should handle the current detail panel
  def current_detail_classname
    "Wizard#{title.strip.delete(' ').gsub(/\(.*\)/, '')}DetailPanel"
  end

  # Returns a key for the current details panel
  #
  # These keys are the snakecased class names just like the keys for pages.
  def current_detail_key
    current_detail_classname.snakecase
  end

  # Returns an instance of the proper detail class.  If one can't be found an generic detail panel will be generated instead,
  def current_details
    c_name = current_detail_classname
    detail_class = Object.const_defined?(c_name.to_sym) ? Object.const_get(c_name.to_sym) : WizardDetailPanel
    detail_class.new(browser, false, self)
  end

  # Populates the current detail page.
  #
  # If data is provided it will be used, otherwise it will be pulled from data magic
  def populate(data = {})
    data = data_for(data_for_key.to_s) if data.empty?
    actual_data = data.fetch(current_detail_key, actual_data)
    current_details.populate(actual_data)
  end

  # Populates to a given point in the process and then stops. To navigate all the way through use :issue as the end_id
  #
  # If data is not provided for a panel it will just be passed over via next.
  #
  # @param end_id [Symbol] The ID of the panel to stop on.  The snakecase version of the classname.  see current_detail_key
  def populate_to(end_id, data = {})
    end_id = "wizard_#{end_id.to_s.snakecase}_detail_panel"
    data = data_for(data_for_key.to_s) if data.empty?
    cur_key = current_detail_key
    until cur_key == end_id
      # binding.pry if  cur_key.to_sym == :wizard_payment_detail_panel && Nenv.debug?
      populate(data)
      next_page unless cur_key.to_sym == :wizard_payment_detail_panel
      cur_key = cur_key.to_sym == :wizard_payment_detail_panel ? end_id : current_detail_key
    end
  end

  # returns true if on the last detail panel
  def last_page?
    false
  end

  # returns the text of any messages on the page
  def messages
    divs(class: 'message').map(&:text)
  end

  # Returns true if there are any warnings on the page
  def warnings?
    images(class: 'warning_icon').count.positive?
  end

  # Safely navigate to the next step
  #
  # This deals with some weirdness where the browser thinks the navigation buttons
  # are visible, but in fact are still under the banner.  Since they're the top thing
  # on the page you can't ask it to scroll something above them on the page so we use a hammer
  # and bang click it instead,
  #
  # Then we wait until we either see that the detail panel has changed or we have warnings present.
  # In the event we see warnings, an exception will be raised with the messages as contents.
  #
  def change_page_with(meth)
    last_detail_key = current_detail_key
    attempts = 1
    begin
      send("#{meth}_element").click!
    rescue Exception => e
      attempts += 1
      # rubocop:disable Lint/Debugger
      binding.pry if attempts > 3 && Nenv.debug?
      # rubocop:enable Lint/Debugger
      retry
    end
    Watir::Wait.until { current_detail_key != last_detail_key || warnings? }
    raise "Could not change wizard page. Messages: #{messages}" if warnings?
  end

  # Used to safely navigate forward instead of just clicking the button
  def next_page
    change_page_with(:next_button)
  end

  # Used to safely navigate backward instead of just clicking the button
  def prev_page
    change_page_with(:prev_button)
  end

  # rubocop:disable Lint/Debugger
  def pry
    binding.pry
    STDOUT.puts 'Line for pry' if Nenv.debug?
  end
  # rubocop:enable Lint/Debugger
end
