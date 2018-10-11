
And(/I create a new policy quote/) do
  on(PolicyCenterPage) do |page|
    page.north_panel.new_policy
  end

  #on(NewSubmissionTabPage).populate

  on(NewSubmissionTabPage) do |page|
    #binding.pry
    page.populate
    grid = page.product_grid
    item = grid.items.first
    str = item.num_to_create.text
    item.num_to_create.set "3"
    binding.pry
  end
end
