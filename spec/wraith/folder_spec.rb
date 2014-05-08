require 'rspec'

require_relative '../../lib/wraith/wraith'
require_relative '../../lib/wraith/folder'
require_relative '../lib/spec_lib'

folder_selenium = Wraith::FolderManager.new('test_selenium_config')

helpers = WraithSpecHelpers.new('spec')

describe Wraith::FolderManager, '#dir' do

  it 'should return the directory(ies) stipulated in the config file' do

   folder_selenium.dir.should == %w[shots]
  end
end

describe Wraith::FolderManager, '#paths' do

  expected_paths =  {
      'home' => '/',
      'uk_index' => '/uk'
  }

  it 'should return the file paths specified when using the selenium config file' do
    folder_selenium.paths.should == expected_paths

  end
end

describe Wraith::FolderManager, '#clear_shots_folder' do

  #make sure the directory is created and full as the method should destroy and recreate it empty
  before(:each) do
    helpers.create_directory(folder_selenium.dir)
    helpers.image_setup(folder_selenium.dir,folder_selenium.paths)
  end

  after(:each) do
    helpers.destroy_directory(folder_selenium.dir)
  end

  it 'should wipe all files and delete the empty shots directory specified in the config file' do

    folder_selenium.clear_shots_folder

    File.directory?(folder_selenium.dir).should == true

    files = Dir.glob(folder_selenium.dir + '/*')
    files.length.should == 0
  end
end

describe Wraith::FolderManager, '#create_folders' do

  it 'should create the directory and all subfolders beneath it based on the configured thumbnails folder and paths' do
    should.false == true
  end
end