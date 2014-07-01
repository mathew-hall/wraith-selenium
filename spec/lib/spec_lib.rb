require 'yaml'
require 'fileutils'

class WraithSpecHelpers

  def initialize(config)
    @spec_config = YAML::load(File.open("configs/" + config + ".yaml"))
  end

  def wraith_instance(wraith_config)
    Wraith::Wraith.new(wraith_config)
  end

  def wraith_configs
    @spec_config['wraith_configs']
  end

  def test_expectations
    @spec_config['test_expectations']
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

  def example_files
    @spec_config['example_files']
  end

  def base_compare_file_examples_url_comparison
    @spec_config['base_compare_file_examples_url_comparison']
  end

  def base_compare_file_examples_browser_comparison
    @spec_config['base_compare_file_examples_browser_comparison']
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

      create_directory(thumbnails_path)

      files = Dir.glob(pdirectory_path + "/*")

      files.each do |file|
        unless File.directory?(file)
          File.delete(file)
        end
      end

      # copy_files(image_store_path, pdirectory_path)

      paths.each_key do |key|
        sub_dir_path = pdirectory_path + '/' + key
        thumbnails_sub_path = thumbnails_path  + '/' + key
        image_store_sub_path = image_store_path + '/' + key

        directory_paths_to_create = [sub_dir_path, thumbnails_sub_path]

        directory_paths_to_create.each do |dpath|
          create_directory(dpath)
        end

        copy_files(image_store_sub_path,sub_dir_path, 45)
        check_files_are_generated(sub_dir_path, '*.', '*', 60)
      end

    end

  end

  def copy_files(from,to,number)
    Dir[from +'/*' ].each do |copied_file|
      unless File.directory?(copied_file)
        FileUtils.cp(copied_file, to)
      end
      iteration = 0
      unless Dir.glob(to + '/*').length >= number || iteration >= 20
        sleep 0.1
        iteration += 1
      end
    end
  end

  #counts and recounts files in directory at intervals until
  #directory appears to have stopped mutating
  def file_count(file_path, regex_hash, ext, total_iterations, wait, mode)
    iteration = 1
    filtered_count = 0
    last_count = 0
    until iteration > total_iterations
      files = Dir.glob(file_path + '/*'  + ext)
      count = files.count
      if count == last_count && count > 0
        #loop through files here to filter on regex and return filtered number
        files.each do |file|
          if /(.*)(#{Regexp.quote(regex_hash['prefix'].to_s)})(.*)(#{Regexp.quote(regex_hash['middle'].to_s)})(.*)(#{Regexp.quote(regex_hash['suffix'].to_s)})(.*)/.match(file)
            filtered_count = filtered_count + 1
          elsif mode == 'required'
            return false
          end
        end
        if mode == 'count'
          return filtered_count
        else
          return true
        end
      else
        last_count = count
      end
      sleep wait
    end
  end

  def check_files_are_generated(file_path, file_regex, ext, required_count)
    iteration = 0
    if file_regex.nil?
      file_regex = '*.'
    end
    until Dir.glob(file_path + '/' + file_regex + ext).length >= required_count || iteration >= 20
      #ugh!
      sleep 0.1
      iteration += 1
    end
  end

  def touch (pdirectory, paths, file, ext)
    paths.each_key do |path|
      full_path = pdirectory + '/' + path + '/' + file + ext
      FileUtils.touch(full_path)
    end
  end

  def loop_and_execute_on_directories(cmd, pdirectory, paths, ext, match=nil)
    paths.each_key do |path|
      full_path = pdirectory + '/' + path
      if cmd == 'create'
        create_directory(full_path)
      elsif cmd == 'wipe'
        wipe_directory(full_path, ext, match)
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

  def wipe_directory(path, ext, match=nil)
    Dir.glob(path + '/*.' + ext).each do |file|
      unless File.directory?(file)
        if match.nil? || file.match(match)
          File.delete(file)
        end
      end
    end
  end

  def destroy_directory(path)
    if File.directory?(path)
      Dir.rmdir path
      end
  end
end