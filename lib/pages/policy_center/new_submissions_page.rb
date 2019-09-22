class NewSubmissionsPage < BasePage
  link_hooked(:add_bop_button, id: 'NewSubmission:NewSubmissionScreen:ProductOffersDV:ProductSelectionLV:0:addSubmission', hooks: WFA_HOOKS)
  span(:title, class: 'g-title')
  def pry
    binding.pry
    STDOUT.puts
  end

  def add_bop
    start_title = title
    add_bop_button
    Watir::Wait.until { start_title != title }
  end
end