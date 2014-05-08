require 'rspec'

require_relative '../../lib/wraith/wraith'
require_relative '../../lib/wraith/images'
require_relative '../lib/spec_lib'

images_webkit = Wraith::Images.new('test_selenium_config')
helpers = WraithSpecHelpers.new('spec')

describe Wraith::Images, '#generate_thumbnails' do



  directory = helpers.directory
  paths = helpers.paths

  before(:each) do
    helpers.create_directory(directory)
    helpers.loop_and_execute_on_directories('create', directory, paths, '')
  end

  after(:each) do
    helpers.loop_and_execute_on_directories('wipe', directory, paths, 'png')
    helpers.loop_and_execute_on_directories('destroy', directory, paths, '')
    helpers.destroy_directory(directory)
  end

  it 'should find zero length files and substitute invalid file' do

    helpers.touch(directory, paths, 'zero', '.png')
    images_webkit.files
    paths.each_key do |path|
      files = Dir.glob(directory + '/' + path + '/*.png')
      files.each do |file|
        File.zero?(file).should == false
      end
    end
  end

end