require 'rspec'

require_relative '../../lib/wraith/wraith'
require_relative '../../lib/wraith/crop'
require_relative '../lib/spec_lib'

helpers = WraithSpecHelpers.new('spec')
configs = helpers.wraith_configs
crop_selenium = Wraith::CropImages.new(configs['test_selenium_url_config'])

test_expectations = helpers.test_expectations

describe Wraith::CropImages, '#crop_value' do

  crop_args = test_expectations['crop_args']
  before(:each) do
    @arg3 = crop_args[2]
    @arg4 = crop_args[3]
  end

  it 'should return argument 3 if argument 1 is greater than argument 2' do

    arg1 = crop_args[0]
    arg2 = crop_args[1]

    returned_value = crop_selenium.crop_value(arg1,arg2,@arg3,@arg4)
    returned_value.should == @arg3
  end

  it 'should return argument 4 if argument 2 is greater than argument 1' do

    arg1 = crop_args[1]
    arg2 = crop_args[0]

    returned_value = crop_selenium.crop_value(arg1,arg2,@arg3,@arg4)
    returned_value.should == @arg4
  end
end

