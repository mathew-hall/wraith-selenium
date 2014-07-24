require_relative File.dirname(__FILE__) + '/../../../spec/lib/spec_lib'
require_relative File.dirname(__FILE__) + '/../../../lib/wraith/cli'

helpers = WraithSpecHelpers.new('spec')
test_expectations = helpers.test_expectations

Given(/^I wish to create and compare screenshots of URLs using (.*)$/) do |driver|
  @driver = driver
end

And(/^I wish to use the engine mode (.*)$/) do |mode|
  @mode = mode
end

And(/^I wish to use a (.*) as a base comparison in all cases$/) do |base_type|
  @base_type = base_type
end


And(/^I want to test a (.*)$/) do |page_or_component|
  @page_or_component = page_or_component
end

And(/^I wish to test on (.*)$/) do |device_or_desktop|
  @config_file = 'test' + '_' + @driver + '_' +  @mode + '_' + @base_type + '_' + @page_or_component  + '_' + device_or_desktop + '_config'
  @cnf_vals = YAML::load(File.open('configs/' + @config_file + '.yaml'))
end

When(/^I capture screen shots for a list of browser widths$/) do
  @cli = Wraith::CLI.new

  @cli.instance_of?(Wraith::CLI).should == true

  @cli.reset_shots(@config_file)

  Dir[test_expectations['shots_directory'] + '/*'].empty?.should == true

  @cli.check_for_paths(@config_file)
  @cli.setup_folders(@config_file)
  @cli.save_images(@config_file)
  @cli.check_images(@config_file)
end

And(/^I crop the screen shots$/) do
  @cli.crop_images(@config_file)

end

And(/^I do diffs of the screen shots against the base image$/) do
  @cli.compare_images(@config_file)

end

And(/^I create thumbnails and a gallery$/) do
  @cli.generate_thumbnails(@config_file)
  @cli.generate_gallery(@config_file)
end

Then(/^I expect to see (.*) (.*) files preserved for each width for (.*)$/) do |expected_file_count,file_type,device_or_desktop|

  extn = '.png'
  if file_type == 'data'
    extn = '.txt'
  end
  shot_directory = @cnf_vals['directory'][0]
  screen_properties = @cnf_vals['screen_properties']
  paths = @cnf_vals['paths']

   paths.each_key do |path|
    full_path = Dir.pwd + '/' + shot_directory + '/' + path
    screen_properties[device_or_desktop].each do |dim|

      dim.is_a?(Array) ? width = dim[0] : width = dim

      regex_hash = {
        'prefix' => width,
        'middle' => '',
        'suffix' => file_type
      }
      count = helpers.file_count(full_path, regex_hash, extn, 100, 2, 'count')
      count.to_s.should == expected_file_count
    end
  end
end

And(/^the filename of the image should reflect that it was created using (.*)$/) do |driver|

  extn = '.png'
  shot_directory = @cnf_vals['directory'][0]
  paths = @cnf_vals['paths']
  regex_hash = {
    'prefix' => '',
    'middle' => driver,
    'suffix' => ''
  }

  paths.each_key do |path|
    full_path = Dir.pwd + '/' + shot_directory + '/' + path
    result = helpers.file_count(full_path, regex_hash, extn, 100, 0.5, 'required')
    result.should == true
  end
end

And(/^the filename of the image should reflect whether it was created using (.*)$/) do  |property|
  expected_browser_device_file_count = test_expectations['base_type_browser_device_file_count']
  shot_directory = @cnf_vals['directory'][0]
  paths = @cnf_vals['paths']
  #reverse mapping of specified driver to the suite which maps to the driver in the config file
  browser_suite  = @cnf_vals['suites'][test_expectations['driver_suites'][@driver]]

  browser_suite.each do |browser|
    regex_hash = {
      'prefix' => '',
      'middle' => property,
      'suffix' => browser
    }

    paths.each_key do |path|
      full_path = Dir.pwd + '/' + shot_directory + '/' + path
      result = helpers.file_count(full_path, regex_hash, '.png', 100, 1.0, 'count')
      result.to_i.should == expected_browser_device_file_count[@mode][@base_type][browser][property].to_i
    end
  end
end

And(/^a gallery of images created as an HTML page$/) do
  shot_directory = @cnf_vals['directory'][0]
  gallery_path = Dir.pwd + '/' + shot_directory +'/gallery.html'
  File.file?(gallery_path).should == true
end

And(/^the gallery page should contain the parameters used as information$/) do
  pending
end

And(/^a thumbnail version should be created for the images at each width giving (.*) images per width for (.*)$/) do |thumbnail_count, device_or_desktop|
  extn = '.png'

  shot_directory = @cnf_vals['directory'][0]
  screen_properties = @cnf_vals['screen_properties']
  paths = @cnf_vals['paths']
  thumbnail_directory = @cnf_vals['thumbnail_directory']

  paths.each_key do |path|
    full_path = Dir.pwd + '/' + shot_directory + '/' + thumbnail_directory + '/' + path
    screen_properties[device_or_desktop].each do |dim|

      dim.is_a?(Array) ? width = dim[0] : width = dim

      regex_hash = {
        'prefix' => width,
        'middle' => '',
        'suffix' => ''
      }
      count = helpers.file_count(full_path, regex_hash, extn, 100, 2, 'count')
      count.to_s.should == thumbnail_count
    end
  end
end

