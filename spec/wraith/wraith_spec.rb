require 'rspec'

require_relative '../../lib/wraith/wraith'
require_relative '../lib/spec_lib'


helpers = WraithSpecHelpers.new('spec')

configs = helpers.wraith_configs

wraith_webkit = Wraith::Wraith.new(configs['test_webkit_url_config'])
wraith_selenium = Wraith::Wraith.new(configs['test_selenium_url_config'])

test_expectations = helpers.test_expectations

describe Wraith, '#directory'  do

  it 'should return the directory specified when using the webkit config file' do
    wraith_webkit.directory.should == test_expectations['shots_directory']
  end

  it 'should return the directory specified when using the selenium config file' do
    wraith_selenium.directory.should == test_expectations['shots_directory']
  end
end

describe Wraith, '#snap_file' do

  it 'should return the snap file specified when using the webkit config file' do
    wraith_webkit.snap_file.should == test_expectations['snap_directory']
  end

  it 'should return the snap file specified when using the selenium config file' do
    wraith_selenium.snap_file.should == ''
  end
end

describe Wraith, '#timeout' do

  expected_timeout = test_expectations['timeout']
  it 'should return the timeout value specified when using the webkit config file' do
    wraith_webkit.timeout.should == expected_timeout
  end

  it 'should return the timeout value specified when using the selenium config file' do
    wraith_selenium.timeout.should == expected_timeout
  end
end

describe Wraith, '#widths' do

  expected_array = test_expectations['width_array']

  it 'should return the widths specified when using the webkit config file' do
    wraith_webkit.widths.should == expected_array
  end

  it 'should return the widths specified when using the selenium config file' do
    wraith_selenium.widths.should == expected_array
  end
end

describe Wraith, '#domains' do

  expected_hash = test_expectations['domains']
  it 'should return the domains specified when using the webkit config file' do
    wraith_webkit.domains.should == expected_hash
  end

  it 'should return the domains specified when using the selenium config file' do
    wraith_selenium.domains.should == expected_hash
  end
end

describe Wraith, '#base_domain' do

  expected_base = test_expectations['domains']['base']

  it 'should return the base domain specified when using the webkit config file' do
    wraith_webkit.base_domain.should == expected_base
  end

  it 'should return the base domain specified when using the selenium config file' do
    wraith_selenium.base_domain.should == expected_base
  end
end

describe Wraith, '#comp_domain' do

  expected_comparison_domain = test_expectations['domains']['compare']
  it 'should return the comp domain specified when using the selenium config file' do
    wraith_webkit.comp_domain.should == expected_comparison_domain
  end

  it 'should return the comp domain specified when using the selenium config file' do
    wraith_selenium.comp_domain.should == expected_comparison_domain
  end
end

describe Wraith, '#base_domain_label' do
  expected_base_label = test_expectations['domain_labels']['base']
  it 'should return the base domain label specified when using the webkit config file' do
    wraith_webkit.base_domain_label.should == expected_base_label
  end

  it 'should return the base domain label specified when using the selenium config file' do
    wraith_selenium.base_domain_label.should == expected_base_label
  end
end

describe Wraith, '#comp_domain_label' do

  expected_comp_label = test_expectations['domain_labels']['compare']
  it 'should return the comp domain label specified when using the webkit config file' do
    wraith_webkit.comp_domain_label.should == expected_comp_label
  end

  it 'should return the comp domain label specified when using the selenium config file' do
    wraith_selenium.comp_domain_label.should == expected_comp_label
  end
end

describe Wraith, '#browser_devices' do

  expected_browser_devices = test_expectations['browser_devices']
  it 'should return the devices mapped to individual browsers when using the selenium config file' do
    wraith_selenium.browser_devices.should == expected_browser_devices
  end
end

describe Wraith, '#spider_file' do

  expected_spider_file = 'spider.txt'
  it 'should return the spider file name specified when using the webkit config file' do
    wraith_webkit.spider_file.should == expected_spider_file
  end

  it 'should return the spider file name specified when using the selenium config file' do
    wraith_selenium.spider_file.should == expected_spider_file
  end
end

describe Wraith, '#spider_days' do

  expected_spider_days = test_expectations['spider_days']
  it 'should return the number of spider days specified when using the webkit config file' do
    wraith_webkit.spider_days.should == expected_spider_days
  end

  it 'should return the number of spider days specified when using the selenium config file' do
    wraith_selenium.spider_days.should == expected_spider_days
  end
end

describe Wraith, '#paths' do

  expected_paths =  helpers.paths

  it 'should return the file paths specified when using the webkit config file' do
    wraith_webkit.paths.should == expected_paths

  end

  it 'should return the file paths specified when using the selenium config file' do
    wraith_selenium.paths.should == expected_paths
  end
end

describe Wraith, '#engine' do
  it 'should return the engine type specified when using the webkit config file' do
    wraith_webkit.engine.should == nil
  end

  it 'should return the engine type specified when using the selenium config file' do
    wraith_selenium.engine.should == test_expectations['test_engine']
  end
end

describe Wraith, '#suites' do

  expected_suites = test_expectations['suites']

  it 'should return the suites of browsers specified when using the webkit config file' do
    wraith_webkit.suites.should == expected_suites
  end

  it 'should return the suites of browsers specified when using the selenium config file' do
    wraith_selenium.suites.should == expected_suites
  end
end

describe Wraith, '#suite' do

  expected_suites = test_expectations['suites']
  it 'should return the suite specified as the current choice to run when using the webkit config file' do
    wraith_webkit.suite.should == expected_suites['webkit']
  end

  it 'should return the suite specified as the current choice to run when using the selenium config file' do
    wraith_selenium.suite.should == expected_suites['standard']
  end
end

describe Wraith, '#fuzz' do

  expected_fuzz = '20%'
  it 'should return the degree of fuzz set for image magick to allow specified when using the webkit config file' do
    wraith_webkit.fuzz.should == expected_fuzz
  end

  it 'should return the degree of fuzz set for image magick to allow specified when using the selenium config file' do
    wraith_selenium.fuzz.should == expected_fuzz
  end
end
