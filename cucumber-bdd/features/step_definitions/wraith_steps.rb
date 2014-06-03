require_relative File.dirname(__FILE__) + '/../../../spec/lib/spec_lib'
require_relative File.dirname(__FILE__) + '/../../../lib/wraith/cli'

helpers = WraithSpecHelpers.new('spec')
test_expectations = helpers.test_expectations

Given(/^I wish to create and compare screenshots of URLs using (.*)$/) do |driver|
  @driver = driver
end

And(/^I wish to use a (.*) as a base comparison in all cases$/) do |base_type|
  @base_type = base_type
  @config_file = 'test' + '_' + @driver + '_' + @base_type + '_config'
  @cnf_vals = YAML::load(File.open("configs/" + @config_file + ".yaml"))
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

Then(/^I expect to see (.*) (.*) files preserved for each width$/) do |base_image_count,file_type|

  extn = '.png'
  if file_type == 'data'
    extn = '.txt'
  end
  shot_directory = @cnf_vals['directory'][0]
  widths = @cnf_vals['screen_widths']
  paths = @cnf_vals['paths']

  paths.each_key do |path|
  full_path = Dir.pwd + '/' + shot_directory + '/' + path
    widths.each do |width|
      count = helpers.file_count(full_path,file_type, extn, 100, 2)
      count.should == base_image_count
    end
  end
end

And(/^the filename of the image should reflect that it was created using (.*)$/) do |driver|
  pending
end

And(/^the filename of the image should reflect that it was represents a given browser width$/) do
  pending
end

And(/^a gallery of images created as an HTML page$/) do
  pending
end

And(/^the gallery page should contain the parameters used as information$/) do
  pending
end

And(/^a thumbnail version should be created for each image$/) do

end