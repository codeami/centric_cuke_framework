# frozen_string_literal: true

# Partial model of the new submissions page
class NewSubmissionsPage < BasePage
  link_hooked(:add_bop_button, id: 'NewSubmission:NewSubmissionScreen:ProductOffersDV:ProductSelectionLV:0:addSubmission', hooks: WFA_HOOKS)
  span(:title, class: 'g-title')

  # rubocop:disable Lint/Debugger
  def pry
    binding.pry
    STDOUT.puts 'Line for pry' if Nenv.debug?
  end
  # rubocop:enable Lint/Debugger

  # Clicks the button to add BOP and blocks until the UI updates.
  def add_bop
    start_title = title
    add_bop_button
    Watir::Wait.until { start_title != title }
  end
end
