Given /^I am on the categories index page$/ do
  visit '/categories'
  page.status_code.should == 200
end

Then /^I should see a list of all the categories$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I add a new category$/ do
  @new_category = 'this_is_an_obvious_test_category'
  fill_in 'new_category', with: @new_category
  click_button 'Add Category'
end

Then /^I should see the new category added to the list$/ do
  @new_category = 'this_is_an_obvious_test_category'
  current_path.should == '/categories'
  page.should have_content(@new_category)
end

When /^I remove a category$/ do
  @new_category = 'this_is_an_obvious_test_category'
  unless page.should have_content(@new_category)
    fill_in 'new_category', with: @new_category
    click_button 'Add Category'
  end
  click_button "this_is_an_obvious_test_category_delete_button"
end

Then /^I shouldn't see the removed category on the list$/ do
  @new_category = 'this_is_an_obvious_test_category'
  current_path.should == '/categories'
  page.should_not have_content(@new_category)
end