require 'rspec'

require_relative '../../lib/wraith/wraith'
require_relative '../../lib/wraith/crop'
require_relative '../lib/spec_lib'

crop_selenium = Wraith::CropImages.new('test_selenium_config')

helpers = WraithSpecHelpers.new('spec')
directory = helpers.directory
thumbnails_dir = helpers.thumbnails_dir
paths = helpers.paths

describe Wraith::CropImages, '#crop_value' do

  before(:each) do
    @arg3 = 30
    @arg4 = 40
  end

  it 'should return argument 4 if argument 1 is greater than argument 2' do

    arg1 = 10
    arg2 = 20

    returned_value = crop_selenium.crop_value(arg1,arg2,@arg3,@arg4)
    returned_value.should == @arg4
  end

  it 'should return argument 3 if argument 2 is greater than argument 1' do

    arg1 = 20
    arg2 = 10

    returned_value = crop_selenium.crop_value(arg1,arg2,@arg3,@arg4)
    returned_value.should == @arg3
  end
end

describe Wraith::CropImages, '#find_heights' do

  before(:all) do
      helpers.create_directory(directory)
      helpers.create_directory(directory + '/' + thumbnails_dir)
      helpers.image_setup(directory,paths)
  end

  after(:all) do
    helpers.loop_and_execute_on_directories('wipe', directory, paths, '*')
    helpers.loop_and_execute_on_directories('destroy', directory, paths, '')
    helpers.loop_and_execute_on_directories('wipe', directory + '/' + thumbnails_dir, paths, '*')
    helpers.loop_and_execute_on_directories('destroy', directory + '/' + thumbnails_dir, paths, '')
    helpers.destroy_directory(directory + '/' + thumbnails_dir)
    helpers.destroy_directory(directory)
  end

  it 'should return the correct height of the file' do

    example_files = helpers.example_files
    expected_height = 748

    example_files.each do |example_file|
      file_height = crop_selenium.find_heights(example_file)
      file_height.should == expected_height
    end
  end

end