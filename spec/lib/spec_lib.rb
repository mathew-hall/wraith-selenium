require 'yaml'
require 'fileutils'

class WraithSpecHelpers

  def initialize(config)
    @spec_config = YAML::load(File.open("configs/" + config + ".yaml"))
  end

  def class_exists?(class_name)
    klass = Module.const_get(class_name)
    return klass.is_a?(Class)
    rescue NameError
    return false
  end

  def directory
    @spec_config['directory'][0]
  end

  def paths
    @spec_config['paths']
  end

  def test_root_match
    @spec_config['test_root_match']
  end

  def image_store_dir
    @spec_config['image_store_dir']
  end

  def thumbnails_dir
    @spec_config['thumbnails_dir']
  end

  def image_setup(pdirectory,paths)
    pwd = Dir.pwd

    unless pwd.match(test_root_match)
      puts "hmmmm....doesn't seem you're working directory is under a test root
            ...stopping as unsafe"
      exit
    else
      #put in config if have time
      pdirectory_path = pwd + '/' + pdirectory
      thumbnails_path = pdirectory_path + '/' + thumbnails_dir
      image_store_path = pwd + '/' + image_store_dir

      files = Dir.glob(pdirectory_path + "/*")

      files.each do |file|
        unless File.directory?(file)
          File.delete(file)
        end
      end

      create_directory(thumbnails_path)
      copy_files(image_store_path, pdirectory_path)

      paths.each_key do |key|
        sub_dir_path = pdirectory_path + '/' + key
        thumbnails_sub_path = thumbnails_path  + '/' + key
        image_store_sub_path = image_store_path + '/' + key

        directory_paths_to_create = [sub_dir_path, thumbnails_sub_path]

        directory_paths_to_create.each do |dpath|

        end

        copy_files(image_store_sub_path,sub_dir_path)
        check_files_are_generated(sub_dir_path, "png", 1)
      end

    end

  end

  def copy_files(from,to)
    Dir[from +'/*' ].each do |copied_file|
      unless File.directory?(copied_file)
        FileUtils.cp(copied_file, to)
      end
    end
  end

  def check_files_are_generated(file_path, ext, count)
    until Dir.glob(file_path + '/*.' + ext).length == count
      sleep 0.1
    end
  end

  def touch (pdirectory, paths, file, ext)
    paths.each_key do |path|
      full_path = pdirectory + '/' + path + '/' + file + ext
      FileUtils.touch(full_path)
    end
  end

  def loop_and_execute_on_directories(cmd, pdirectory, paths, ext)
    paths.each_key do |path|
      full_path = pdirectory + '/' + path
      if cmd == 'create'
        create_directory(full_path)
      elsif cmd == 'wipe'
        wipe_directory(full_path, ext)
      elsif cmd == 'destroy'
        destroy_directory(full_path)
      end
    end
  end

  def create_directory(path)
    unless File.directory?(path)
      Dir.mkdir(path)
    end
  end

  def wipe_directory(path, ext)
    Dir.glob(path + '/*.' + ext).each do |file|
      unless File.directory?(file)
        File.delete(file)
      end
    end
  end

  def destroy_directory(path)
    Dir.rmdir path
  end
end