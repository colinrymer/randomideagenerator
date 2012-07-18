Given /^I am on the random idea page$/ do
  visit '/random'
  @idea = find_by_id('new_idea')
end

When /^I refresh the page$/ do
  visit '/random'
end

Then /^I should see a newly generated idea\.$/ do
  find_by_id('new_idea') != @idea
end