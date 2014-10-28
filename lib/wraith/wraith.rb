require 'yaml'

class Wraith::Wraith
  attr_accessor :config

  def initialize(config_name)
    @config = YAML::load(File.open("configs/#{config_name}.yaml"))
  end

  def base_browser
    @config['base_browser']
  end

  def base_domain_label
    domains.keys[0]
  end

  def base_domain(base_type)
    if base_type =='url'
      domains[base_domain_label]
    else
      comp_domain
    end
  end

  def base_type
    @config['base_type']
  end

  def browser_devices
    if @config.has_key?('browser_devices')
      @config['browser_devices']
    else
      nil
    end
  end
  
  def get_domain(url)
    return url.sub(/https?:\/\//,"").split("/")[0]
  end
  
  def ready(driver)
    driver.execute_script("return document.readyState == 'complete' && (typeof $ == 'undefined' || !$.active)")
  end

  def login(driver, url)
    #Probably, e.g. we are at www.google.com and get sent to www.bing.com
    puts "Was redirected from #{url} to #{driver.current_url}. Will try to login."
    begin
      unless @config.has_key?("credentials")
        puts "No credentials supplied for login. Won't capture #{url}"
        return false
      end
         
      credentials = @config["credentials"]
      
      username_field = driver.find_element(:name, credentials["username_field"])
      password_field = driver.find_element(:name, credentials["password_field"])
      login_button = driver.find_element(:name, credentials["login_button"])
      
      username = credentials["username"]
      password = credentials["password"]
      
      
      username_field.send_keys(username)
      password_field.send_keys(password)
      
      login_button.click
#      sleep 2
      wait = Selenium::WebDriver::Wait.new(:timeout => 30)
      wait.until{
       ready(driver) 
      }
      
      unless driver.current_url.start_with?("https://" + get_domain(url))
        puts "Login doesn't seem to have worked. Still on #{driver.current_url} but expected https://#{get_domain(url)}. Abandoning"
        return false
      end
      
    rescue
      puts "Redirection doesn't seem to be a login page. Failing capture for #{url}"
      return false
    end
    return true
    
  end

  def capture_page_image(driver, browser, url, props, file_name)

    width = props[:dimensions][0]
    height = props[:dimensions][1]
    if (defined?(driver)) && driver.instance_of?(Selenium::WebDriver::Driver)
      begin
        driver.manage.window.resize_to(width, height)
      end

      
      driver.get(url)
      
      #Have we been redirected?
      unless driver.current_url.start_with?("https://" + get_domain(url))
        unless login(driver,url)
          puts "Couldn't log in for #{url}"
          return
        end
      end
      driver.get(url)
      #do we have a view port origin configured? - if so use javascript to scroll to it
      if check_viewport_origin(props[:viewport_origin])
        begin
          javascript = 'window.scrollBy(' + props[:viewport_origin][0].to_s + ',' + props[:viewport_origin][1].to_s + ')'
          driver.execute_script(javascript, '')
          sleep 5
        end
      end
      if wait_until_element(props[:wait_until_element])
        begin
          wait = Selenium::WebDriver::Wait.new(:timeout => 30) # seconds
          wait.until { ready(driver) }
        end
      end
      driver.save_screenshot(file_name)
    else
      command = "#{browser}" + ' ' + "#{@config['options'][@config['suite']]}" + ' ' + "#{snap_file}"  + ' ' + "#{url}" + ' ' + "#{width}" + ' ' + "#{file_name}"
      puts `#{command}`
    end
  end

  def check_base_browser(base_type,base_browser)
    if base_type == 'url'
      true
    elsif base_type == 'browser' && base_browser.length > 0
      true
    else
      false
    end
  end

  def check_domains(base_type,hash)
    urls = hash[base_type]

    urls.each_key do |label|
      if urls[label].empty?
        return false
      end
    end

    true
  end

  def check_viewport_origin(viewport_origin)
    if viewport_origin.nil?
      false
    elsif !viewport_origin.is_a?(Array)
      false
    elsif viewport_origin[0].nil?  || viewport_origin[0].to_s !~ /^\d+$/
      false
    elsif viewport_origin[1].nil?  || viewport_origin[1].to_s !~ /^\d+$/
      false
    else
      true
    end
  end

  def compare_base_to_base
    @config['compare_base_to_base']
  end

  def comp_domain
    domains[comp_domain_label]
  end

  def comp_domain_label
    domains.keys[1]
  end

  def self.crop_images(file, width, height, output)
    # For compatibility with windows file structures switch commenting on the following 2 lines
    unless width
      puts `convert #{file} -background none -extent 0x#{height} #{output}`
    else
      puts `convert #{file} -background none -extent #{width}x#{height} #{output}`
    end
    # puts `convert #{crop.gsub('/', '\\')} -background none -extent 0x#{height} #{output.gsub('/', '\\')}`
  end

  def crop_images(crop, height)
    if has_stopped_mutating(crop)
      self.class.crop_images
    end
  end

  def crops_directory
    @config['crops_directory']
  end

  def create_cropped_file_path(original_file, file_height)
    rel_path,extn = original_file.split('.')
    rel_path_array = rel_path.split('/')
    rel_path_array.shift
    name = rel_path_array.pop
    remnant_path = rel_path_array.join('/')
    crops_directory_path = directory + '/' + crops_directory + '/' + remnant_path
    unless Dir.exists? crops_directory_path
      FileUtils.mkdir_p crops_directory_path
    end
    crops_directory_path + '/' + name + '_cropped_height_' + file_height.to_s + '.' + extn
  end

  def default_screen_height
    @config['default_screen_height']
  end

  def default_parameters
    @config['default_parameters']
  end

  def default_wait_until_element
    @config['default_wait_until_element']
  end

  # TODO:unit test for this method
  def determine_file_version(file_properties,height_of_comparator)
    cropped_file_version = create_cropped_file_path(file_properties[:file],height_of_comparator)
    if File.exist?(cropped_file_version)
      find_image_dimensions(cropped_file_version,'all',true)
    else
      file_properties
    end
  end

  def directory
    @config['directory'].first
  end

  def domains
    @config['domains'][base_type]
  end

  def engine
    @config['engine'][@config['suite']]
  end

  def engine_mode
    mode = @config['engine_mode']
    if mode.nil?
      mode = 'local'
    end
    mode
  end

# TODO: add test for hash parameter
  def find_image_dimensions(file,dimensions='all',use_hash=false)
    File.open(file, 'rb') do |fh|
      size = ImageSize.new(fh.read).size
      if dimensions == 'all' && use_hash
        dim = Hash.new
        dim[:file] = file
        dim[:width] = size[0]
        dim[:height] = size[1]
        return dim
      elsif dimensions == 'all'
        return size
      elsif dimensions == 'width'
        return size[0]
      elsif dimensions == 'height'
        return size[1]
      end
    end
  end

  def fuzz
    @config['fuzz']
  end

  def get_files_on_regex(files,regex,stop_regex)
    remnant= []
    slice = []
    index = 0
    count = 0
    property = nil
    delete_indexes = []
    files.each do |file|
      if file.match(regex)
        break if !property.nil? && !file.match(property)
        slice.push(file)
        delete_indexes.push(index)
        count = count + 1
        property = file.split(/_/)[0]
      elsif file.match(stop_regex) && count > 0
        break
      end
      index = index + 1
    end
    file_index = 0
    files.each do |file|
       unless number_in_array(file_index,delete_indexes)
         remnant.push(file)
       end
       file_index = file_index + 1
    end
    return slice, remnant
  end

  def grid_url
    @config['grid_url']
  end

  def has_stopped_mutating(filename)
    old_file_size = 1
    new_file_size = 2
    time_spent = 0
    sleep_time = 0.1
    max_time = 5
    #check that file has stopped mutating
    until old_file_size == new_file_size || time_spent > max_time
      old_file_size = File.size(filename)
      sleep sleep_time
      time_spent = time_spent + sleep_time
      new_file_size = File.size(filename)
    end
    if time_spent > max_time
      false
    else
      true
    end
  end

  def number_in_array(number,array)
    array.each do |element|
      if number == element
        return true
      end
    end
    false
  end

  def paths
    @config['paths']
  end

  def screenshot_bias
    @config['screenshot_bias']
  end

  def screen_properties
    @config['screen_properties']
  end

  def snap_file
    @config['snap_file'][@config['suite']]
  end

  def spider_file
    @config['spider_file'] ? @config['spider_file'] : 'spider.txt'
  end

  def spider_days
    @config['spider_days']
  end

  def suite
    suites[@config['suite']]
  end

  def suites
    @config['suites']
  end

  def thumbnail_directory
    @config['thumbnail_directory']
  end

  def thumbnail_image(png_path, output_path, pwd)

    if defined?(pwd)
      png_path = pwd + '/' + png_path
      output_path =  pwd + '/' + output_path
    end
    # For compatibility with windows file structures switch commenting on the following 2 lines
    `convert #{png_path} -thumbnail 200 -crop 200x200+0+0 #{output_path}`
    #`convert #{png_path.gsub('/', '\\')} -thumbnail 200 -crop 200x200+0+0 #{output_path}`
  end

  def timeout
    @config['timeout']
  end

  def wait_until_element(element=nil)
    if !element.nil?
      element
    else
      default_wait_until_element
    end
  end

end
