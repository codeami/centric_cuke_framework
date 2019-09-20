class NewSubmissionsPage < BasePage
  link_hooked(:add_bop, id: 'NewSubmission:NewSubmissionScreen:ProductOffersDV:ProductSelectionLV:0:addSubmission', hooks: WFA_HOOKS)

  def pry
    binding.pry
    STDOUT.puts
  end
end