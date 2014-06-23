require 'rspec'

require_relative '../../lib/wraith/wraith'
require_relative '../../lib/wraith/images'
require_relative '../lib/spec_lib'

helpers = WraithSpecHelpers.new('spec')
configs = helpers.wraith_configs
images_webkit = Wraith::Images.new(configs['test_selenium_url_config'])

describe Wraith::Images, '#generate_thumbnails' do

  directory = helpers.directory
  thumbnails_dir = helpers.thumbnails_dir
  paths = helpers.paths

  before(:all) do
    helpers.loop_and_execute_on_directories('wipe', directory + '/' + thumbnails_dir, paths, '*')
    helpers.loop_and_execute_on_directories('destroy', directory + '/' + thumbnails_dir, paths, '')
    helpers.loop_and_execute_on_directories('wipe', directory, paths, '*')
    helpers.loop_and_execute_on_directories('destroy', directory, paths, '')
    helpers.create_directory(directory)
    helpers.loop_and_execute_on_directories('create', directory, paths, '')
  end

  after(:all) do
    helpers.loop_and_execute_on_directories('wipe', directory, paths, '*')
    helpers.loop_and_execute_on_directories('destroy', directory, paths, '')
    helpers.destroy_directory(directory)
  end

  it 'should find zero length files and substitute invalid file' do

    helpers.touch(directory, paths, 'zero', '.png')
    images_webkit.files
    paths.each_key do |path|
      files = Dir.glob(directory + '/' + path + '/*.png')
      files.each do |file|
        expect(File.zero?(file)).to eq false
      end
    end
  end

end