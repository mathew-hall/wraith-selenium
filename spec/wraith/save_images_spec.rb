require 'rspec'

require_relative '../../lib/wraith/wraith'
require_relative '../../lib/wraith/save_images'
require_relative '../lib/spec_lib'

helpers = WraithSpecHelpers.new('spec')
configs = helpers.wraith_configs

save_images_selenium = Wraith::SaveImages.new(configs['test_selenium_url_config'])
test_expectations = helpers.test_expectations

describe Wraith::SaveImages, '#file_names' do

  it 'should construct image files names from the browser, device and other specifics' do

    file_name = save_images_selenium.file_names('320','home','firefox','desktop','base')

    file_name.should == test_expectations['file_name']
  end
end
