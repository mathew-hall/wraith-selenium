require_relative File.dirname(__FILE__) + '/../../../spec/lib/spec_lib'
require_relative File.dirname(__FILE__) + '/../../../lib/wraith/cli'

helpers = WraithSpecHelpers.new('spec')
test_expectations = helpers.test_expectations

Given(/^I wish to create and compare screenshots of URLs using (.*)$/) do |driver|
  @driver = driver
end

And(/^I wish to use the engine mode (.*) with (.*) as a base comparison$/) do |mode,base_type|
  @mode = mode
  @base_type = base_type
end

# And(/^I wish to use a (.*) as a base comparison in all cases$/) do |base_type|
#   @base_type = base_type
# end


And(/^I want to test a (.*) on (.*)$/) do |page_or_component,device_or_desktop|
  @page_or_component = page_or_component
  @config_file = 'test' + '_' + @driver + '_' +  @mode + '_' + @base_type + '_' + @page_or_component  + '_' + device_or_desktop + '_config'
  @cnf_vals = YAML::load(File.open('configs/' + @config_file + '.yaml'))
end

# And(/^I wish to test on (.*)$/) do |device_or_desktop|
#   @config_file = 'test' + '_' + @driver + '_' +  @mode + '_' + @base_type + '_' + @page_or_component  + '_' + device_or_desktop + '_config'
#   @cnf_vals = YAML::load(File.open('configs/' + @config_file + '.yaml'))
# end

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

# Then(/^I expect to see (.*) (.*) files preserved for each width for (.*)$/) do |expected_file_count,file_type,device_or_desktop|
Then(/^I expect to see (.*) base, (.*) compare, (.*) diff, (.*) data files preserved for each width for (.*)$/) do |exp_base_cnt,exp_compare_cnt,exp_data_cnt,exp_diff_cnt,device_or_desktop|

  file_type_counts = Hash.new()
  file_type_counts[:base] = exp_base_cnt
  file_type_counts[:compare] = exp_compare_cnt
  file_type_counts[:data] = exp_data_cnt
  file_type_counts[:diff] = exp_diff_cnt

  shot_directory = @cnf_vals['directory'][0]
  screen_properties = @cnf_vals['screen_properties']
  paths = @cnf_vals['paths']

  file_type_counts.each do |key,value|
    file_type = key.to_s
    file_type == 'data' ? extn = '.txt' : extn = '.png'

    paths.each_key do |path|
      full_path = Dir.pwd + '/' + shot_directory + '/' + path
      screen_properties[device_or_desktop].each do |props|

        props.is_a?(Hash) ? width = props[:name] : width = props

        regex_hash = {
          'prefix' => width,
          'middle' => '',
          'suffix' => file_type
        }
        count = helpers.file_count(full_path, regex_hash, extn, 100, 2, 'count')
        expect(count.to_s).to eq value
      end
    end
  end
end

# And(/^the filename of the image should reflect that it was created using (.*)$/) do |driver|
#
#   extn = '.png'
#   shot_directory = @cnf_vals['directory'][0]
#   paths = @cnf_vals['paths']
#   regex_hash = {
#     'prefix' => '',
#     'middle' => driver,
#     'suffix' => ''
#   }
#
#   paths.each_key do |path|
#     full_path = Dir.pwd + '/' + shot_directory + '/' + path
#     result = helpers.file_count(full_path, regex_hash, extn, 100, 0.5, 'required')
#     expect(result).to eq true
#   end
# end

And(/^the filename of the image should reflect that it was created using (.*), (.*), (.*) and (.*)$/) do  |driver,mode,base_type,device_or_desktop|
  expected_browser_device_file_count = test_expectations['base_type_browser_device_file_count']
  extn = '.png'
  shot_directory = @cnf_vals['directory'][0]
  paths = @cnf_vals['paths']
  #reverse mapping of specified driver to the suite which maps to the driver in the config file
  browser_suite  = @cnf_vals['suites'][test_expectations['driver_suites'][@driver]]
  browser_suite.each do |browser|
    regex_hash = {
      'prefix' => mode,
      'middle' => device_or_desktop,
      'suffix' => browser
    }

    paths.each_key do |path|
      full_path = Dir.pwd + '/' + shot_directory + '/' + path
      result = helpers.file_count(full_path, regex_hash, '.png', 100, 1.0, 'count')
      expect(result.to_i).to eq expected_browser_device_file_count[mode][base_type][browser][device_or_desktop].to_i
    end
  end
end

And(/^a gallery of images created as an HTML page$/) do
  shot_directory = @cnf_vals['directory'][0]
  gallery_path = Dir.pwd + '/' + shot_directory +'/gallery.html'
  expect(File.file?(gallery_path)).to eq true
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
    screen_properties[device_or_desktop].each do |props|

      props.is_a?(Hash) ? width = props[:name] : width = props

      regex_hash = {
        'prefix' => width,
        'middle' => '',
        'suffix' => ''
      }
      count = helpers.file_count(full_path, regex_hash, extn, 100, 2, 'count')
      expect(count.to_s).to eq thumbnail_count
    end
  end
end

