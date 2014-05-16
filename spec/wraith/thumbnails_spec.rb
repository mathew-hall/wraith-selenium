require 'rspec'

require_relative '../../lib/wraith/thumbnails'
require_relative '../../lib/wraith/wraith'
require_relative '../lib/spec_lib'

thumbnails_webkit = Wraith::Thumbnails.new('test_selenium_config')

describe Wraith::Thumbnails, '#generate_thumbnails' do

  helpers = WraithSpecHelpers.new('spec')
  directory = helpers.directory
  thumbnails_dir = helpers.thumbnails_dir
  paths = helpers.paths

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

  it 'should generate thumbnails of the created images' do

    thumbnails_webkit.generate_thumbnails

    paths.each_key do |path|
      thumbnails_file_count = Dir.glob(directory + '/' + thumbnails_dir + '/' + path + '/*.png').length
      thumbnails_file_count.should == 45
    end
  end
end