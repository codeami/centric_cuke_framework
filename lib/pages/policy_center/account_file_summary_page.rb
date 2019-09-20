class AccountFileSummaryPage < BasePage
  link_hooked(:new_submission_link, id: 'AccountFile:AccountFileMenuActions:AccountFileMenuActions_Create:AccountFileMenuActions_NewSubmission-itemEl', hooks: WFA_HOOKS)
  link_hooked(:toggle_actions_menu, id: 'AccountFile:AccountFileMenuActions')

  def new_submission
    toggle_actions_menu unless new_submission_link?
    new_submission_link
  end

  def pry
    binding.pry
    STDOUT.puts
  end
end