Feature: Capturing browser screenshots of URLS and calculating diffs between a base browser or URL

  Scenario Outline: 1: Using a given browser driver and comparing screen shots against a base image
    Given I wish to create and compare screenshots of URLs using <driver>
    And I wish to use a <base_type> as a base comparison in all cases
    When I capture screen shots for a list of browser widths
    And I crop the screen shots
    And I do diffs of the screen shots against the base image
    Then I expect to see a diff image preserved in each case
    And the filename of the image should reflect that it was created using <driver>
    And the filename of the image should reflect that it was represents a given browser width
    And a gallery of images created as an HTML page
    And the gallery page should contain the parameters used as information
  Examples:
    |driver   |base_type|
    |phantomJS|url      |
    |phantomJS|browser  |
    |selenium |url      |
    |selenium |browser  |

