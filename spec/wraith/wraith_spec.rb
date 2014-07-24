require 'rspec'

require_relative '../../lib/wraith/wraith'
require_relative '../lib/spec_lib'

helpers = WraithSpecHelpers.new('spec')

directory = helpers.directory
thumbnails_dir = helpers.thumbnails_dir
paths = helpers.paths

configs = helpers.wraith_configs

wraith_webkit_url = Wraith::Wraith.new(configs['test_webkit_url_config'])
wraith_selenium_url = Wraith::Wraith.new(configs['test_selenium_url_config'])
wraith_selenium_browser = Wraith::Wraith.new(configs['test_selenium_browser_config'])
wraith_selenium_grid_browser = Wraith::Wraith.new(configs['test_selenium_grid_browser_config'])
wraith_selenium_browser_component = Wraith::Wraith.new(configs['test_selenium_browser_component_config'])
test_expectations = helpers.test_expectations

describe Wraith, '#directory'  do

  it 'should return the directory specified when using the webkit config file' do
    expect(wraith_webkit_url.directory).to eq test_expectations['shots_directory']
  end

  it 'should return the directory specified when using the selenium config file' do
    expect(wraith_selenium_url.directory).to eq test_expectations['shots_directory']
  end
end

describe Wraith, '#snap_file' do

  it 'should return the snap file specified when using the webkit config file' do
    expect(wraith_webkit_url.snap_file).to eq test_expectations['snap_directory']
  end

  it 'should return the snap file specified when using the selenium config file' do
    expect(wraith_selenium_url.snap_file).to eq ''
  end
end

describe Wraith, '#timeout' do

  it 'should return the timeout value specified when using the selenium config file' do
    expect(wraith_selenium_url.timeout).to eq test_expectations['timeout']
  end
end

describe Wraith, '#widths' do

  expected_array = test_expectations['screen_properties']

  it 'should return the widths specified when using the webkit config file' do
    expect(wraith_webkit_url.screen_properties).to match_array expected_array['standard']
  end

  it 'should return the widths specified when using the selenium config file' do
    expect(wraith_selenium_browser_component.screen_properties).to match_array expected_array['advanced']
  end
end

describe Wraith, '#domains' do

  expected_hash = test_expectations['domains']
  it 'should return the domains specified when using the webkit config file' do
    expect(wraith_webkit_url.domains).to eq expected_hash
  end

  it 'should return the domains specified when using the selenium config file' do
    expect(wraith_selenium_url.domains).to eq expected_hash
  end
end

describe Wraith, '#base_domain' do

  expected_base = test_expectations['domains']['base']
  expected_compare = test_expectations['domains']['compare']

  it 'should return the base domain specified when using the webkit config file and url comparison' do
    expect(wraith_webkit_url.base_domain('url')).to eq expected_base
  end

  it 'should return the base domain specified when using the selenium config file and url comparison' do
    expect(wraith_selenium_url.base_domain('url')).to eq expected_base
  end

  it 'should return the compare domain specified when using the selenium config file and browser comparison' do
      expect(wraith_selenium_url.base_domain('browser')).to eq expected_compare
  end
end

describe Wraith, '#comp_domain' do

  expected_comparison_domain = test_expectations['domains']['compare']
  it 'should return the comp domain specified when using the selenium config file' do
    expect(wraith_webkit_url.comp_domain).to eq expected_comparison_domain
  end

  it 'should return the comp domain specified when using the selenium config file' do
    expect(wraith_selenium_url.comp_domain).to eq expected_comparison_domain
  end
end

describe Wraith, '#base_domain_label' do
  expected_base_label = test_expectations['domain_labels']['base']
  it 'should return the base domain label specified when using the webkit config file' do
    expect(wraith_webkit_url.base_domain_label).to eq expected_base_label
  end

  it 'should return the base domain label specified when using the selenium config file' do
    expect(wraith_selenium_url.base_domain_label).to eq expected_base_label
  end
end

describe Wraith, '#comp_domain_label' do

  expected_comp_label = test_expectations['domain_labels']['compare']
  it 'should return the comp domain label specified when using the webkit config file' do
    expect(wraith_webkit_url.comp_domain_label).to eq expected_comp_label
  end

  it 'should return the comp domain label specified when using the selenium config file' do
    expect(wraith_selenium_url.comp_domain_label).to eq expected_comp_label
  end
end

describe Wraith, '#browser_devices' do

  expected_browser_devices = test_expectations['browser_devices']
  it 'should return the devices mapped to individual browsers when using the selenium config file' do
    expect(wraith_selenium_url.browser_devices).to eq expected_browser_devices
  end
end

describe Wraith, '#spider_file' do

  expected_spider_file = 'spider.txt'
  it 'should return the spider file name specified when using the webkit config file' do
    expect(wraith_webkit_url.spider_file).to eq expected_spider_file
  end

  it 'should return the spider file name specified when using the selenium config file' do
    expect(wraith_selenium_url.spider_file).to eq expected_spider_file
  end
end

describe Wraith, '#spider_days' do

  expected_spider_days = test_expectations['spider_days']
  it 'should return the number of spider days specified when using the webkit config file' do
    expect(wraith_webkit_url.spider_days).to eq expected_spider_days
  end

  it 'should return the number of spider days specified when using the selenium config file' do
    expect(wraith_selenium_url.spider_days).to eq expected_spider_days
  end
end

describe Wraith, '#paths' do

  expected_paths =  helpers.paths

  it 'should return the file paths specified when using the webkit config file' do
    expect(wraith_webkit_url.paths).to eq expected_paths

  end

  it 'should return the file paths specified when using the selenium config file' do
    expect(wraith_selenium_url.paths).to eq expected_paths
  end
end

describe Wraith, '#engine' do
  it 'should return the engine type specified when using the webkit config file' do
    expect(wraith_webkit_url.engine).to eq nil
  end

  it 'should return the engine type specified when using the selenium config file' do
    expect(wraith_selenium_url.engine).to eq test_expectations['test_engine']
  end
end

describe Wraith, '#engine_mode' do
  it 'should return the default engine type \'local\'  when using the webkit config file' do
    expect(wraith_webkit_url.engine_mode).to eq test_expectations['engine_mode']['default']
  end

  it 'should return the engine type specified when using the selenium browser (local) config file' do
      expect(wraith_selenium_browser.engine_mode).to eq test_expectations['engine_mode']['local']
  end

  it 'should return the engine type specified when using the selenium browser (grid) config file' do
    expect(wraith_selenium_grid_browser.engine_mode).to eq test_expectations['engine_mode']['selenium_grid']
  end
end

describe Wraith, '#suites' do

  expected_suites = test_expectations['suites']

  it 'should return the suites of browsers specified when using the webkit config file' do
    expect(wraith_webkit_url.suites).to eq expected_suites
  end

  it 'should return the suites of browsers specified when using the selenium config file' do
    expect(wraith_selenium_url.suites).to eq expected_suites
  end
end

describe Wraith, '#suite' do

  expected_suites = test_expectations['suites']
  it 'should return the suite specified as the current choice to run when using the webkit config file' do
    expect(wraith_webkit_url.suite).to eq expected_suites['webkit']
  end

  it 'should return the suite specified as the current choice to run when using the selenium config file' do
    expect(wraith_selenium_url.suite).to eq expected_suites['standard']
  end
end

describe Wraith, '#grid_url' do

  it 'should return the configured grid url' do
    expected_grid_url = test_expectations['grid_url']

    expect(wraith_selenium_grid_browser.grid_url).to eq expected_grid_url
  end
end

describe Wraith, '#default_screen_height' do

  it 'should return the default screen height in the configuration file' do

    expected_height = test_expectations['default_screen_height']

    expect(wraith_selenium_browser.default_screen_height).to eq expected_height

  end
end

describe Wraith, '#fuzz' do

  expected_fuzz = test_expectations['fuzz']
  it 'should return the degree of fuzz set for image magick specified when using the webkit url config file' do
    expect(wraith_webkit_url.fuzz).to eq expected_fuzz
  end

  it 'should return the degree of fuzz set for image magick specified when using the selenium url config file' do
    expect(wraith_selenium_url.fuzz).to eq expected_fuzz
  end
end

describe Wraith, '#base_type' do
  expected_base_types = test_expectations['base_types']
  it 'should return the base type set when using the webkit url config file' do
    expect(wraith_webkit_url.base_type).to eq expected_base_types['url']
  end

  it 'should return the base type set when using the selenium url config file' do
    expect(wraith_selenium_url.base_type).to eq expected_base_types['url']
  end

  it 'should return the base type set when using the selenium browser config file' do
    expect(wraith_selenium_browser.base_type).to eq expected_base_types['browser']
  end

end

describe Wraith, '#compare_base_to_base' do

  it 'should return the base type set when using the selenium url config file' do
    expect(wraith_selenium_url.compare_base_to_base.to_s).to eq 'false'
  end

  it 'should return the base type set when using the selenium browser config file' do
    expect(wraith_selenium_browser.compare_base_to_base.to_s).to eq 'true'
  end

end

describe Wraith, '#check_domains' do
  it 'should return false if base type is url and base url not set' do

    domains = { 'url' =>    {
                            'base' => '',
                            'compare' => 'http://www.bbc.co.uk'
                            },
                'browser' =>  {
                              'compare' => 'http://www.bbc.co.uk'
                              }
              }

    expect(wraith_selenium_url.check_domains('url',domains)).to eq false
  end

  it 'should return false if base type is url and compare url not set' do

    domains = { 'url' =>    {
                            'base' => 'http://www.bbc.co.uk',
                            'compare' => ''
                            },
                'browser' =>  {
                              'compare' => 'http://www.bbc.co.uk'
                              }
              }

    expect(wraith_selenium_url.check_domains('url',domains)).to eq false

  end

  it 'should return false if base type is browser and target url not set' do

    domains = { 'url' =>    {
                            'base' => 'http://www.bbc.co.uk',
                            'compare' => 'http://www.bbc.co.uk'
                            },
                'browser' =>  {
                              'compare' => ''
                              }
              }

    expect(wraith_selenium_url.check_domains('browser',domains)).to eq false

  end

  it 'should return true if base type is url and base and compare urls set' do

    domains = { 'url' =>    {
                            'base' => 'http://www.bbc.co.uk',
                            'compare' => 'http://www.bbc.co.uk'
                            },
                'browser' =>  {
                                'compare' => ''
                              }
                  }

    expect(wraith_selenium_url.check_domains('url',domains)).to eq true
  end

  it 'should return true if base type is browser and target url set' do

    domains = { 'url' =>      {
                              'base' => 'http://www.bbc.co.uk',
                              'compare' => ''
                              },
                'browser' =>  {
                              'compare' => 'http://www.bbc.co.uk'
                              }
              }

    expect(wraith_selenium_url.check_domains('browser',domains)).to eq true

  end
end

describe Wraith, '#base_browser' do
  it 'should return the base browser specified in the config file' do

    expected_base_browser = test_expectations['base_browser']
    expect(wraith_selenium_browser.base_browser).to eq expected_base_browser
  end
end

describe Wraith, '#check_base_browser' do

  it 'should return true if base_type is url no matter what base_browser is set to' do

    expect(wraith_selenium_browser.check_base_browser('url','')).to eq true
  end

  it 'should return true is base_type is browser and base_browser is set to a string value' do

    expect(wraith_selenium_browser.check_base_browser('browser','chrome')).to eq true
  end

  it 'should return false if base_type is not set' do

    expect(wraith_selenium_browser.check_base_browser('','chrome')).to eq false
  end

  it 'should return false if base_type is browser but base_browser is not set' do

    expect(wraith_selenium_browser.check_base_browser('browser','')).to eq false
  end
end

describe Wraith::Wraith, '#check_viewport_origin' do

  it 'should return false if viewport_origin object is nil' do
    expect(wraith_selenium_browser.check_viewport_origin(nil)).to eq false
  end

  it 'should return false if viewport_origin object is not an array' do
    expect(wraith_selenium_browser.check_viewport_origin(Hash.new)).to eq false
  end

  it 'should return false if viewport_origin x coord is not an Number' do
    expect(wraith_selenium_browser.check_viewport_origin(['x',200])).to eq false
  end

  it 'should return false if viewport_origin y coord is not an Number' do
    expect(wraith_selenium_browser.check_viewport_origin([200,'y'])).to eq false
  end

  it 'should return true if viewport_origin is an array object and first two elements are integers' do
    expect(wraith_selenium_browser.check_viewport_origin([200,200])).to eq true
  end
end

describe Wraith::Wraith, '#get_files_from_array_until_regex' do

  it 'should return base and compare array slice and the remnant array based on a regex for url based comparison' do

    files = helpers.base_compare_file_examples_url_comparison

    slice, remnant = wraith_selenium_browser.get_files_from_array_while_regex(files,'base','compare')
    expect(slice).to match_array(test_expectations['base_compare_file_examples_url_comparison']['base'])

    slice2, remnant2 = wraith_selenium_browser.get_files_from_array_while_regex(remnant,'compare','base')
    expect(slice2).to match_array(test_expectations['base_compare_file_examples_url_comparison']['compare'])
  end

  it 'should return base and compare array slice and the remnant array based on a regex for browser based comparison' do

    files = helpers.base_compare_file_examples_browser_comparison

    slice, renmant = wraith_selenium_browser.get_files_from_array_while_regex(files,'base','compare')
    expect(slice).to match_array(test_expectations['base_compare_file_examples_browser_comparison']['base'])

    slice2, renmant2 = wraith_selenium_browser.get_files_from_array_while_regex(renmant,'compare','base')
    expect(slice2).to match_array(test_expectations['base_compare_file_examples_browser_comparison']['compare'])
  end

end

describe Wraith, '#default_wait_until_element' do

  it 'should return the id of a page element that must be present before the wait condition is satisfied' do
    expect(wraith_selenium_url.default_wait_until_element).to eq test_expectations['wait_until_element']['default']
  end

end

describe Wraith, '#wait_until_element' do

  it 'should return the passed in wait value if set' do
    expect(wraith_selenium_url.wait_until_element(test_expectations['wait_until_element']['passed_in'])).to eq test_expectations['wait_until_element']['passed_in']
  end

  it 'should return the passed in the default value if the passed in value is nil' do
     expect(wraith_selenium_url.wait_until_element(nil)).to eq test_expectations['wait_until_element']['default']
  end

  it 'should return the passed in the default value if no value passed in' do
       expect(wraith_selenium_url.wait_until_element).to eq test_expectations['wait_until_element']['default']
  end
end

describe Wraith, '#default_parameters' do

  it 'should return the default parameters key structure' do

    expected_default_parameters = test_expectations['default_parameters']

    expect(wraith_selenium_grid_browser.default_parameters).to eq expected_default_parameters
  end
end

describe Wraith::CropImages, '#find_heights' do

  before do
      helpers.create_directory(directory)
      helpers.create_directory(directory + '/' + thumbnails_dir)
      helpers.image_setup(directory,paths)
  end

  after do
    helpers.loop_and_execute_on_directories('wipe', directory, paths, '*')
    helpers.loop_and_execute_on_directories('destroy', directory, paths, '')
    helpers.loop_and_execute_on_directories('wipe', directory + '/' + thumbnails_dir, paths, '*')
    helpers.loop_and_execute_on_directories('destroy', directory + '/' + thumbnails_dir, paths, '')
    helpers.destroy_directory(directory + '/' + thumbnails_dir)
    helpers.destroy_directory(directory)
  end

  it 'should return the correct height of the file' do

    example_files = helpers.example_files
    expected_height = test_expectations['height_of_file']

    example_files.each do |example_file|
      file_height = wraith_selenium_browser.find_image_dimensions(example_file,'height')
      expect(file_height).to eq expected_height
    end
  end

  it 'should return the correct width of the file' do

    example_files = helpers.example_files
    actual_file_widths = []
    expected_widths = test_expectations['widths_of_files']

    example_files.each do |example_file|
      actual_file_widths.push(wraith_selenium_browser.find_image_dimensions(example_file,'width'))
    end

    expect(actual_file_widths).to match_array(expected_widths)
  end

end