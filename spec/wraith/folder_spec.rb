require 'rspec'

require_relative '../../lib/wraith/wraith'
require_relative '../../lib/wraith/folder'
require_relative '../lib/spec_lib'

helpers = WraithSpecHelpers.new('spec')
configs = helpers.wraith_configs
folder_selenium = Wraith::FolderManager.new(configs['test_selenium_url_config'])

directory = helpers.directory
thumbnails_dir = helpers.thumbnails_dir
paths = helpers.paths

test_expectations = helpers.test_expectations

describe Wraith::FolderManager, '#dir' do

  it 'should return the directory(ies) stipulated in the config file' do

   folder_selenium.dir.should == test_expectations['shots_directory']
  end
end

describe Wraith::FolderManager, '#paths' do

  it 'should return the file paths specified when using the selenium config file' do
    folder_selenium.paths.should == helpers.paths
  end
end

describe Wraith::FolderManager, '#clear_shots_folder' do

  #make sure the directory is created and full as the method should destroy and recreate it empty
  before do
    helpers.create_directory(folder_selenium.dir)
    helpers.image_setup(folder_selenium.dir,folder_selenium.paths)
  end

  after do
    helpers.destroy_directory(folder_selenium.dir)
  end

  it 'should wipe all files and delete the empty shots directory specified in the config file' do

    folder_selenium.clear_shots_folder

    File.directory?(folder_selenium.dir).should == true

    files = Dir.glob(folder_selenium.dir + '/*')
    expect(files.length).to eq 0
  end
end

describe Wraith::FolderManager, '#create_folders' do

  before do
    helpers.loop_and_execute_on_directories('wipe', directory, paths, '*')
    helpers.loop_and_execute_on_directories('destroy', directory, paths, '')
    helpers.loop_and_execute_on_directories('wipe', directory + '/' + thumbnails_dir, paths, '*')
    helpers.loop_and_execute_on_directories('destroy', directory + '/' + thumbnails_dir, paths, '')
  end

  it 'should create the directory and all subfolders beneath it based on the configured thumbnails folder and paths' do
    folder_selenium.create_folders

    directory = helpers.directory
    thumbnails_dir = helpers.thumbnails_dir

    helpers.paths.each_key do |path|
      directory_sub_path = directory + '/' + path
      thumbnail_sub_path = directory + '/' + thumbnails_dir + '/' + path

      expect(File.directory?(directory_sub_path)).to eq true
      expect(File.directory?(thumbnail_sub_path)).to eq true
    end
  end
end