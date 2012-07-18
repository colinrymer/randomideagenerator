Feature: The new ideas should come from two Wikipedia categories
  Scenario: I should be able to see all the categories
    Given I am on the categories index page
    Then I should see a list of all the categories

  Scenario: I should be able to add a new category
    Given I am on the categories index page
    When I add a new category
    Then I should see the new category added to the list

  Scenario: I should be able to remove a category
    Given I am on the categories index page
    When I remove a category
    Then I shouldn't see the removed category on the list