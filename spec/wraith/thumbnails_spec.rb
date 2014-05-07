require 'rspec'

require_relative '../../lib/wraith/thumbnails'
require_relative '../../lib/wraith/wraith'
require_relative '../lib/spec_lib'

thumbnails_webkit = Wraith::Thumbnails.new('test_webkit_config')

describe Wraith::Thumbnails, '#generate_thumbnails' do

  helpers = WraithSpecHelpers.new("spec")
  directory = helpers.directory
  thumbnails_dir = helpers.thumbnails_dir

  paths = helpers.paths

  before(:each) do
      helpers.image_setup(directory,paths)
  end

  after(:each) do
    helpers.loop_and_execute_on_directories('wipe', directory, paths, 'png')
    helpers.loop_and_execute_on_directories('destroy', directory, paths, '')
  end

  it 'should generate thumbnails of the created images' do

    thumbnails_webkit.generate_thumbnails

    thumbnails_file_count = Dir.glob(directory + '/' + thumbnails_dir + '/*.png').length

    thumbnails_file_count.should == 1
  end
end