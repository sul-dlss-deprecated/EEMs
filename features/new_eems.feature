Feature: New EEMs
  In order to create a new EEM
  As a selector
  I want to select an item to collect
  
  Scenario: Widget Exists
    Given I am on the widget
    Then I should see "Found on this site:"
    Then I should see "Title of work:"
    Then I should see "Created by:"
    Then I should see "Direct link to PDF:"
    Then I should see "Copyright:"
    Then I should see "Purchase:"
    

  Scenario: Submit an EEM
    Given I am on the widget
    When I fill in the following:
      | Found on this site: | http://www.dfg.ca.gov/wildlife/wap/report.html |
      | Created by: | Test User |
      | Title of work: | California Wildlife Action Plan Report |
      | Direct link to PDF: | http://www.dfg.ca.gov/wildlife/WAP/docs/report/full-report.pdf |
    And I press "Save to dashboard"
    Then I should see "Your selection is being uploaded"
    