require 'rspec'

require_relative '../../lib/wraith/wraith'
require_relative '../lib/spec_lib'


wraith_webkit = Wraith::Wraith.new('test_webkit_config')
wraith_selenium = Wraith::Wraith.new('test_selenium_config')

describe Wraith, '#directory'  do

  it 'should return the directory specified when using the webkit config file' do
    wraith_webkit.directory.should == 'shots'
  end

  it 'should return the directory specified when using the selenium config file' do
    wraith_selenium.directory.should == 'shots'
  end
end

describe Wraith, '#snap_file' do

  it 'should return the snap file specified when using the webkit config file' do
    wraith_webkit.snap_file.should == 'javascript/snap.js'
  end

  it 'should return the snap file specified when using the selenium config file' do
    wraith_selenium.snap_file.should == ''
  end
end

describe Wraith, '#timeout' do

  expected_timeout = 20
  it 'should return the timeout value specified when using the webkit config file' do
    wraith_webkit.timeout.should == expected_timeout
  end

  it 'should return the timeout value specified when using the selenium config file' do
    wraith_selenium.timeout.should == expected_timeout
  end
end

describe Wraith, '#widths' do

  expected_array = [320, 600, 768, 1024, 1280]

  it 'should return the widths specified when using the webkit config file' do
    wraith_webkit.widths.should == expected_array
  end

  it 'should return the widths specified when using the selenium config file' do
    wraith_selenium.widths.should == expected_array
  end
end

describe Wraith, '#domains' do

  expected_hash = {
                    'english' => 'http://www.live.bbc.co.uk/news',
                    'russian' =>  'http://www.live.bbc.co.uk/russian'
                  }
  it 'should return the domains specified when using the webkit config file' do
    wraith_webkit.domains.should == expected_hash
  end

  it 'should return the domains specified when using the selenium config file' do
    wraith_selenium.domains.should == expected_hash
  end
end

describe Wraith, '#base_domain' do

  expected_base = 'http://www.live.bbc.co.uk/news'

  it 'should return the base domain specified when using the webkit config file' do
    wraith_webkit.base_domain.should == expected_base
  end

  it 'should return the base domain specified when using the selenium config file' do
    wraith_selenium.base_domain.should == expected_base
  end
end

describe Wraith, '#comp_domain' do

  expected_comparison_domain = 'http://www.live.bbc.co.uk/russian'
  it 'should return the comp domain specified when using the selenium config file' do
    wraith_webkit.comp_domain.should == expected_comparison_domain
  end

  it 'should return the comp domain specified when using the selenium config file' do
    wraith_selenium.comp_domain.should == expected_comparison_domain
  end
end

describe Wraith, '#base_domain_label' do
  expected_base_label = 'english'
  it 'should return the base domain label specified when using the webkit config file' do
    wraith_webkit.base_domain_label.should == expected_base_label
  end

  it 'should return the base domain label specified when using the selenium config file' do
    wraith_selenium.base_domain_label.should == expected_base_label
  end
end

describe Wraith, '#comp_domain_label' do

  expected_comp_label = 'russian'
  it 'should return the comp domain label specified when using the webkit config file' do
    wraith_webkit.comp_domain_label.should == expected_comp_label
  end

  it 'should return the comp domain label specified when using the selenium config file' do
    wraith_selenium.comp_domain_label.should == expected_comp_label
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

  expected_spider_days = [10]
  it 'should return the number of spider days specified when using the webkit config file' do
    wraith_webkit.spider_days.should == expected_spider_days
  end

  it 'should return the number of spider days specified when using the selenium config file' do
    wraith_selenium.spider_days.should == expected_spider_days
  end
end

describe Wraith, '#paths' do

  expected_paths =  {
                      'home' => '/',
                      'uk_index' => '/uk'
                    }

  it 'should return the file paths specified when using the webkit config file' do
    wraith_webkit.paths.should == expected_paths

  end

  it 'should return the file paths specified when using the selenium config file' do
    wraith_selenium.paths.should == expected_paths
  end
end

describe Wraith, '#engine' do
  it 'should return the engine type specified when using the webkit config file' do
    wraith_webkit.engine.should == ''
  end

  it 'should return the engine type specified when using the selenium config file' do
    wraith_selenium.engine.should == 'selenium'
  end
end

describe Wraith, '#suites' do

  expected_suites = {
                        'webkit' => %w[phantomjs],
                        'standard' => %w['android' 'chrome' 'firefox' 'ie']
                    }

  it 'should return the suites of browsers specified when using the webkit config file' do
    wraith_webkit.suites.should == expected_suites
  end

  it 'should return the suites of browsers specified when using the selenium config file' do
    wraith_selenium.suites.should == expected_suites
  end
end

describe Wraith, '#suite' do
  it 'should return the suite specified as the current choice to run when using the webkit config file' do
    wraith_webkit.suite.should == %w[phantomjs]
  end

  it 'should return the suite specified as the current choice to run when using the selenium config file' do
    wraith_selenium.suite.should == %w[android chrome firefox ie]
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
