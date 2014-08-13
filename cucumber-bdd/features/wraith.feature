Feature: Capturing browser screenshots of URLS and calculating diffs between a base browser or URL

  Scenario Outline: 1: Using a given browser driver and comparing screen shots against a base image
    Given I wish to create and compare screenshots of URLs using <driver>
    And I wish to use the engine mode <mode> with <base_type> as a base comparison
    And I want to test a <page_or_component> on <device_or_desktop>
    When I capture screen shots for a list of browser widths
    And I crop the screen shots
    And I do diffs of the screen shots against the base image
    And I create thumbnails and a gallery
    Then I expect to see <base_image_count> base, <compare_image_count> compare, <diff_image_count> diff, <data_file_count> data files preserved for each width for <device_or_desktop>
    And the filename of the image should reflect that it was created using <driver>, <mode>, <base_type> and <device_or_desktop>
    And a thumbnail version should be created for the images at each width giving <thumbnail_count> images per width for <device_or_desktop>
    And a gallery of images created as an HTML page
  Examples:
    |driver       |mode   |base_type  |page_or_component  |base_image_count |compare_image_count|diff_image_count |data_file_count|thumbnail_count|device_or_desktop|
    #phantomJS url based page comparison
    |phantomjs    |local  |url        |page               | 1               |1                  |1                |1              |3              |desktop          |
    #selenium url based page comparison
    #|selenium     |local  |url        |page               | 3               |3                  |3                |3              |9              |desktop          |
    #selenium browser based page comparison
    #|selenium     |local  |browser    |page               | 1               |3                  |3                |3              |7              |desktop          |
    #selenium url based page comparison using locally attached devices. This example uses an iPad with webdriver installed upon it
    #|selenium    |local  |url        |page               | 1               |1                  |1                |1              |3              |device           |
    #selenium browser based component comparison using page origin repositioning
    #|selenium     |local  |browser    |component          | 1               |2                  |2                |2              |5              |desktop          |
    #selenium browser based comparison
    #|selenium     |grid|browser  |page             | 1               |2                  |2                |2              |5              |desktop          |





