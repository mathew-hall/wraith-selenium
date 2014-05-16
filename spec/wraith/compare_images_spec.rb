require 'rspec'
require_relative '../../lib/wraith/wraith'
require_relative '../../lib/wraith/compare_images'
require_relative '../lib/spec_lib'

compare_images_selenium = Wraith::CompareImages.new('test_selenium_config')

helpers = WraithSpecHelpers.new('spec')
directory = helpers.directory
thumbnails_dir = helpers.thumbnails_dir
paths = helpers.paths

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
      diff_png_count = Dir.glob(directory + '/' + path + '/*diff.png').length
      diff_png_count.should == 15
    end
  end

  it 'should do compare images and save data text files' do

    paths.each_key do |path|
      data_txt_count = Dir.glob(directory + '/' + path + '/*data.txt').length
      data_txt_count.should == 15
    end
  end
end