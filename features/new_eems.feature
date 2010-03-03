Feature: New EEMs
  In order to create a new EEM
  As a selector
  I want to select an item to collect
  
  Scenario: Widget Exists
    Given I am on the widget
    Then I should see "Direct link to PDF"
    
  Scenario: Submit item
    Given I am on the widget
    And I fill in "eem_sourceUrl" with "http://www.ntsb.gov/Publictn/Pub_list.htm"     
    And I press "Save to dashboard"