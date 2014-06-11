Feature: Capturing browser screenshots of URLS and calculating diffs between a base browser or URL

  Scenario Outline: 1: Using a given browser driver and comparing screen shots against a base image
    Given I wish to create and compare screenshots of URLs using <driver>
    And I wish to use a <base_type> as a base comparison in all cases
    When I capture screen shots for a list of browser widths
    And I crop the screen shots
    And I do diffs of the screen shots against the base image
    And I create thumbnails and a gallery
    Then I expect to see <base_image_count> base files preserved for each width for <device_or_desktop>
    And I expect to see <compare_image_count> compare files preserved for each width for <device_or_desktop>
    And I expect to see <diff_image_count> diff files preserved for each width for <device_or_desktop>
    And I expect to see <data_file_count> data files preserved for each width for <device_or_desktop>
    And the filename of the image should reflect that it was created using <driver>
    And the filename of the image should reflect whether it was created using <device_or_desktop>
    And a thumbnail version should be created for the images at each width giving <thumbnail_count> images per width
    And a gallery of images created as an HTML page
    And the gallery page should contain the parameters used as information
  Examples:
    |driver       |base_type|base_image_count |compare_image_count|diff_image_count |data_file_count|thumbnail_count|device_or_desktop|
    |phantomjs    |url      | 1               |1                  |1                |1              |3              |desktop          |
    |selenium     |url      | 2               |2                  |2                |2              |6              |desktop          |
    |selenium     |browser  | 16              |16                 |16               |16             |6              |desktop          |


