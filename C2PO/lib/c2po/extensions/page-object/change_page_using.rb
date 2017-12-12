# frozen_string_literal: true

## PageObject namespace for monkey patching
module PageObject
  extend Forwardable
  def_delegators :root, :visible?, :present?, :exists?

  def change_page_using(element, opts)
    opts[:current_url] ||= @browser.url
    send(element.to_sym)
    wait_for_url_change(opts)
  end

  def wait_for_url_change(opts)
    url_now = opts.fetch(:current_url, @browser.url)
    Watir::Wait.until { @browser.url != url_now }
    wait_for_ajax
    page = nil
    page = on_page(opts[:target_page].to_s.to_page_class) if opts[:target_page]
    opts[:factory]&.current_page = page
    page
  end
end
