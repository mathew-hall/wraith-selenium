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

    file_name = save_images_selenium.file_names('320','home', 'linux', 'firefox','desktop','base')

    expect(file_name).to eq test_expectations['file_name']
  end
end

#driver module code tested here
describe Wraith::SaveImages, '#os_string' do

  it 'should return the remote operating system used by a selenium grid for the test as a string' do

    os = save_images_selenium.os_string('grid','Linux')

    expect(os).to eq test_expectations['os_string']['grid']
  end


  it 'should return the local operating system used for the test as a string' do

    @os = save_images_selenium.os_string('local', nil)
    boolean_flag = false
    #the precise result will differ depending on the local os you are running on
    #but should always match one of the os's within the expectation array
    test_expectations['os_string']['local'].each do |os_type|
      if @os == os_type
        boolean_flag = true
      end
    end

    expect(boolean_flag).to eq true

  end
end

describe Wraith::SaveImages, '#get_capabilities_array' do

  it 'should return the existing array if present' do

    cap_array = test_expectations['capabilities_array']

    returned_array = save_images_selenium.get_capabilities_array(cap_array)

    expect(returned_array).to match_array cap_array
  end

  it 'should return a new array with one element consisting of an empty hash if object is nil' do

    returned_array = save_images_selenium.get_capabilities_array(nil)

    expect(returned_array.is_a?(Array)).to eq true
    expect(returned_array.length).to eq 1

    expect(returned_array[0].is_a?(Hash)).to eq true
    expect(returned_array[0].keys.length).to eq 0
  end
end

describe Wraith::SaveImages, '#get_url' do

  cap_array = test_expectations['capabilities_array']
  expected_cabability_url = cap_array[0][:url]
  expected_selenium_grid_url = test_expectations['grid_url']

  it 'should return the selenium grid url if the engine_mode is set to \'grid\'' do
    returned_url = save_images_selenium.get_url('grid', expected_selenium_grid_url, expected_cabability_url)
    expect(returned_url).to eq expected_selenium_grid_url
  end

  it 'should return the capabilities url if the engine_mode is set to \'local\'' do
    returned_url = save_images_selenium.get_url('local', expected_selenium_grid_url, expected_cabability_url)
    expect(returned_url).to eq expected_cabability_url
  end
end

describe Wraith::SaveImages, '#is_url_properly_set' do

  cap_array = test_expectations['capabilities_array']
  capability_url = cap_array[0][:url]

  it 'should always return true if the engine_mode  \'local\' and device = \'desktop\'' do
    is_properly_set = save_images_selenium.is_url_properly_set('local','desktop', nil)
    expect(is_properly_set).to eq true
  end

  it 'should return true if the engine_mode = \'grid\' and the capabilities url is set' do
    is_properly_set = save_images_selenium.is_url_properly_set('grid','desktop', capability_url)
    expect(is_properly_set).to eq true
  end

  it 'should return true if the device != \'desktop\' and the capabilities url is set' do
    is_properly_set = save_images_selenium.is_url_properly_set('local','desktop', capability_url)
    expect(is_properly_set).to eq true
  end

  it 'should return false if the engine_mode = \'grid\' and the capabilities url is not set' do
    is_properly_set = save_images_selenium.is_url_properly_set('grid','desktop', nil)
    expect(is_properly_set).to eq false
  end

  it 'should return false if the device != \'desktop\' and the capabilities url is not set' do
    is_properly_set = save_images_selenium.is_url_properly_set('local','ipad', nil)
    expect(is_properly_set).to eq false
  end
end

#driver module code tested here
describe Wraith::SaveImages, '#os_set' do

  it 'should return false if a remote operating system is not set as a capability if running in grid mode' do

    is_os_set = save_images_selenium.os_set('grid',nil)

    expect(is_os_set).to eq false
  end

  it 'should return true if a remote operating system is set as a capability if running in grid mode' do

    is_os_set = save_images_selenium.os_set('grid', 'Linux')

    expect(is_os_set).to eq true
  end

  it 'should always return true if engine is running locally' do

    is_os_set = save_images_selenium.os_set('local',nil)

    expect(is_os_set).to eq true
  end
end
