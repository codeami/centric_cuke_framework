require_relative 'wizard_detail_panels'

class WizardPanel < BasePage
  span(:title, class: 'g-title')
  link(:next_button, id: 'SubmissionWizard:Next')
  link(:prev_button, id: 'SubmissionWizard:Prev')
  link(:quote, text: 'Quote')
  link(:save_draft, text: 'Save Draft')
  gw_dropdown( :close_options, text: 'Close Options')

  def data_for_key
    :wizard_panel
  end

  def current_detail_classname
    "Wizard#{title.strip.delete(' ').gsub(/\(.*\)/, '')}DetailPanel"
  end

  def current_detail_key
    current_detail_classname.snakecase
  end

  def current_details
    c_name = current_detail_classname
    detail_class = Object.const_defined?(c_name.to_sym) ? Object.const_get(c_name.to_sym) : WizardDetailPanel
    detail_class.new(browser, false, self)
  end

  def populate(data = {})
    data = data_for(data_for_key.to_s) if data.empty?
    actual_data = data.fetch(current_detail_key, {})
    current_details.populate(actual_data)
  end

  def populate_to(end_id, data = {})
    end_id = "wizard_#{end_id.to_s.snakecase}_detail_panel"
    data = data_for(data_for_key.to_s) if data.empty?
    cur_key = current_detail_key
    until cur_key == end_id
      #binding.pry if  cur_key.to_sym == :wizard_payment_detail_panel
      populate(data)
      next_page unless cur_key.to_sym == :wizard_payment_detail_panel
      cur_key = cur_key.to_sym == :wizard_payment_detail_panel ? end_id : current_detail_key
    end
  end

  def populate_to_end(data={})
    data = data_for(data_for_key.to_s) if data.empty?
    until last_page?
      populate(data)
      next_page
    end
  end

  def last_page?
    false
  end

  def messages
    divs(class: 'message').map(&:text)
  end

  def warnings?
    images(class: 'warning_icon').count.positive?
  end

  def change_page_with(meth)
    last_detail_key = current_detail_key
    attempts = 1
    begin
      send("#{meth}_element").click!
    rescue Exception => ex
      attempts += 1
      binding.pry if attempts > 3
      retry
    end
    Watir::Wait.until { current_detail_key != last_detail_key || warnings? }
    raise "Could not change wizard page. Messages: #{messages}" if warnings?
  end

  def next_page
    change_page_with(:next_button)
  end

  def prev_page
    change_page_with(:prev_button)
  end

  def pry
    binding.pry;2
  end
end