Feature: Generate new idea
  Scenario: New idea is generated
    Given I am on the random idea page
    When I refresh the page
    Then I should see a newly generated idea.