require 'rspec'

require_relative '../../lib/wraith/thumbnails'
require_relative '../../lib/wraith/wraith'
require_relative '../lib/spec_lib'

helpers = WraithSpecHelpers.new('spec')
configs = helpers.wraith_configs
thumbnails_webkit = Wraith::Thumbnails.new(configs['test_selenium_url_config'])

test_expectations = helpers.test_expectations

describe Wraith::Thumbnails, '#generate_thumbnails' do

  directory = helpers.directory
  thumbnails_dir = helpers.thumbnails_dir
  paths = helpers.paths

  before do
    helpers.create_directory(directory)
    helpers.create_directory(directory + '/' + thumbnails_dir)
    helpers.image_setup(directory,paths)
  end

  after do
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
      expect(thumbnails_file_count).to eq test_expectations['thumbnails_file_count']
    end
  end
end