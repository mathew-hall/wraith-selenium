# Wraith-Selenium

[![Build Status](https://secure.travis-ci.org/BBC-News/wraith.png?branch=master)](http://travis-ci.org/BBC-News/wraith)
[![Code Climate](https://codeclimate.com/github/BBC-News/wraith.png)](https://codeclimate.com/github/BBC-News/wraith)

 * Website: http://responsivenews.co.uk
 * Source: http://github.com/bbc-news/wraith

Wraith-Selenium is an augmentation of the BBC Wraith gem by the Friday design agency.

The original Wraith is a screenshot comparison tool, created by developers at BBC News.


## What is it?

The original Wraith uses either [PhantomJS](http://phantomjs.org) or
[SlimerJS](http://slimerjs.org) to create screen-shots of different environments
and then creates a diff of the two images, the affected areas are highlighted in
blue.


![Photo of BBC News with a
diff](http://bbc-news.github.io/wraith/img/320_diff.png)

Wraith-Selenium adds the following capabilities to Wraith

1. Selenium integration, both running locally on a desktop or on a selenium grid
2. Browser to browser screenshot comparison
3. Page component-based comparison

GENERAL APPROACH
================

In general code has been added or changed within the original Wraith classes.
A new driver code module has also been added. 

The addition of the new functionality to the Wraith gem has added considerable 
complexity to the code base. In order to keep the code maintainable, over 100 
RSpec unit tests have been added and a single Cucumber BDD scenario outline with 6 examples. 
The original Wraith tests have been deleted.

Each cucumber scenario covers a major area of functionality, although necessarily these
overlap considerably. Each use their own test configuration file located in
<ROOT>/spec/resources/configs. The test configuration
files are extensively documented and can be used as templates for production.
 
These are: 

test_phantomjs_local_url_page_desktop_config.yaml - used for running the pre-existing Wraith 
functionality using phantomJS.

test_selenium_grid_browser_page_desktop_config.yaml - used for running
using a selenium grid and browser-based comparison.

test_selenium_local_browser_component_desktop_config.yaml - used for running
selenium locally using locally installed desktop browsers (chrome,safari) with
browser-based comparison and testing page components rather than whole pages.

test_selenium_local_url_page_desktop_config.yaml - used for running
selenium locally using locally installed desktop browsers with
url-based comparison.

test_selenium_local_url_page_device_config.yaml - used for running selenium 
locally and testing locally attached devices (in this case an iPad 2 attached
to a Mac Pro machine) with url-based comparison.

The central idea behind the creation of these scenarios is both to maintain the Wraith-Selenium 
code but also to properly document the greatly expanded number of configuration options properly.

Most but not all of the cucumber scenarios can run simultaneously. However some, such as the
scenario for running a selenium grid, necessarily rely on a different initial set up and 
must be run in isolation.


SELENIUM INTEGRATION
====================

You can run selenium locally, using a combination of local browsers on the 
'desktop', against locally attached 'devices' or a combination of the two. 
If running a browser as a device then as you would expect you need to configure 
the URL to copy of webdriver running on the device and the precise device name. 
See the example config files in /spec/resources/configs for details.

Running in grid mode gives you the usual basic selenium capabilites, including the
ability to pass multiple different browser versions and platforms to the grid 
for management.

As with the original Wraith gem, details of the environment used to capture each
screenshot (browser, browser platform, platform as so on, is preserved in the 
screen shot file name and thumbnail file name and later parsed for use in the gallery.

Selenium was found to have a few idiosyncracies, most notably the different way
it interpretes browser width for different browsers.  This cause some issues with 
browse-based comparison (see below for discussion). 


BROWSER-BASED COMPARISON
========================

Wraith used url-based comparison. That is, screenshots taken of different urls 
from the same browser could be compared against each other. This is ideal for, say,
comparing web sites in different test environments.

Wraith-Selenium retains this functionality but also adds browser-based comparison.
Browser-based comparison is necessary to minimise the substantial overhead of 
development and testing teams checking a web site between different browsers and
browser versions.

Unfortunately, Selenium interpretes browser width different according to browser, browser version 
and even the width stipulated. This means that the first time you run a browser-based
comparison, some of the diff images produced may be invalid as diffs can only
be done on screenshots on identical size. To overcome this, you must manually 
inspect the widths of the screenshots produced and add a bias term in the config
file. See the test configuration files for further details.

Browser-based comparison is a one-to-many rather than one-to-one comparison
relationship, and this has necessitated the rewriting of how file comparison is done.
For one thing, file crops do not now overwrite the original screenshot but are
stored in a separate directory for later access. The reason for this is that one base file may
have to be cropped to several different sizes to compare against different comparison files.

PAGE COMPONENT COMPARISONS
==========================

The default behaviour using Wraith is to load a page and change the page width  in order
to check responsive design.

However, in many cases it may be required just to check the responsiveness of a
page component rather than the whole page itself.

It is possible in Wraith-Selenium to change the page origin and dimensions of the 
page, thereby allowing several different components on a single page to be screen shot
and then compared either on a different url or a different browser basis.

At the time of writing this functionality is fairly immature, having been successfully
tested only in chrome and safari. It is known not to work in firefox due to the different
way Firefox handles screenshots, and a workaround at the cropping stage will 
almost certainly be necessary in order to rectify this.


## Requirements

To read our detailed instructions for setup and install, as well as example configs, visit [wraith docs](http://bbc-news.github.io/wraith/index.html)

## Installation

Open terminal and run

    gem install wraith

You can then run the following to create a template snap.js and config file:

    wraith setup

Alternatively you can clone the repo.

    git clone https://github.com/BBC-News/wraith
    cd wraith
    bundle install

## Using Wraith
You can type `wraith` into terminal to bring up the list of commands, but the one to start Wraith is

```sh
wraith capture config_name
```

This assumes that your snap.js and config.yaml are in the folders that were created on setup. There are other commands also available, these all expect a config_name to be passed as an option. Wraith will look for the config file at `configs/[config_name].yaml`.  

```sh
  wraith capture config_name             # A full Wraith job
  wraith compare_images config_name      # compares images to generate diffs
  wraith crop_images config_name         # crops images to the same height
  wraith setup_folders config_name       # create folders for images
  wraith generate_gallery config_name    # create page for viewing images
  wraith generate_thumbnails config_name # create thumbnails for gallery
  wraith reset_shots config_name         # removes all the files in the shots folder
  wraith save_images config_name         # captures screenshots
  wraith setup                           # creates config folder and default config
```

## Output

After each screenshot is captured, the compare task will run, this will output a diff.png and a data.txt.  The data.txt for each file will show the number of pixels that have changed.  There is a main data.txt which is in the root of the output folder that will combine all of these values to easier view all the pixel changes.

## Gallery

A gallery is available to view each of the images and the respective diff images located in the shots folder once all the images have been compared.

##Running Tests
 
Both Rspec and Cucumber tests are designed to run using the <ROOT>/spec/resources as the
working directory.

To run the cucumber features:

cucumber --color -r ../../cucumber-bdd/features

The tests will not work correctly unless the working directory is properly set,
as they rely on accessing and creating files and folders beneath this root.

## Contributing

If you want to add functionality to this project, pull requests are welcome.

 * Create a branch based off master and do all of your changes with in it.
 * If you have to pause to add a 'and' anywhere in the title, it should be two pull requests.
 * Make commits of logical units and describe them properly
 * Check for unnecessary whitespace with git diff --check before committing.
 * If possible, submit tests to your patch / new feature so it can be tested easily.
 * Assure nothing is broken by running all the test
 * Please ensure that it complies with coding standards.

**Please raise any issues with this project as a GitHub issue.**

## Changelog - updated 2014-02-09
We have released Wraith as a Ruby Gem!!  There is a new CLI to better interact with Wraith and it's commands.

## License

Wraith is available to everyone under the terms of the Apache 2.0 open source license.
Take a look at the LICENSE file in the code.

## Credits

 * [Dave Blooman](http://twitter.com/dblooman)
 * [John Cleveley](http://twitter.com/jcleveley)
 * [Simon Thulbourn](http://twitter.com/sthulbourn)
 * [Andrew Tekle-Cadman, Future Visible Ltd.](http://www.linkedin.com/in/andrewcadman)
