# frozen_string_literal: true

# Model of the WRG account summary page
class AccountFileSummaryPage < BasePage
  link_hooked(:new_submission_link, id: 'AccountFile:AccountFileMenuActions:AccountFileMenuActions_Create:AccountFileMenuActions_NewSubmission-itemEl', hooks: WFA_HOOKS)
  link_hooked(:toggle_actions_menu, id: 'AccountFile:AccountFileMenuActions')

  def new_submission
    toggle_actions_menu unless new_submission_link?
    new_submission_link
  end

  # rubocop:disable Lint/Debugger
  def pry
    binding.pry
    STDOUT.puts 'Line for pry' if Nenv.cuke_debug?
  end
  # rubocop:enable Lint/Debugger
end
