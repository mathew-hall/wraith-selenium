require 'rspec'

require_relative '../../lib/wraith/wraith'
require_relative '../../lib/wraith/compare_images'
require_relative '../lib/spec_lib'

helpers = WraithSpecHelpers.new('spec')
configs = helpers.wraith_configs

compare_images_selenium = Wraith::CompareImages.new(configs['test_selenium_url_config'])

directory = helpers.directory
thumbnails_dir = helpers.thumbnails_dir
paths = helpers.paths

test_expectations = helpers.test_expectations

describe Wraith::CompareImages, '#compare_images' do

  before(:all) do
    helpers.create_directory(directory)
    helpers.create_directory(directory + '/' + thumbnails_dir)
    helpers.image_setup(directory,paths)

    compare_images_selenium.compare_images
  end

  after(:all) do
    helpers.loop_and_execute_on_directories('wipe', directory, paths, '*')
    helpers.loop_and_execute_on_directories('destroy', directory, paths, '')
    helpers.loop_and_execute_on_directories('wipe', directory + '/' + thumbnails_dir, paths, '*')
    helpers.loop_and_execute_on_directories('destroy', directory + '/' + thumbnails_dir, paths, '')
    helpers.destroy_directory(directory + '/' + thumbnails_dir)
    helpers.destroy_directory(directory)
  end

  it 'should do compare images and save those comparisons and data text files' do

    paths.each_key do |path|
      diff_png_count = Dir.glob(directory + '/' + path + test_expectations['extn_diff_png']).length
      diff_png_count.should == test_expectations['diff_png_count']
    end
  end

  it 'should do compare images and save data text files' do

    paths.each_key do |path|
      data_txt_count = Dir.glob(directory + '/' + path + test_expectations['extn_data_txt']).length
      data_txt_count.should == test_expectations['data_txt_count']
    end
  end
end