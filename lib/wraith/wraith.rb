require 'yaml'

class Wraith::Wraith
  attr_accessor :config

  def initialize(config_name)
    @config = YAML::load(File.open("configs/#{config_name}.yaml"))
  end

  def directory
    @config['directory'].first
  end

  def snap_file
    @config['snap_file'][@config['suite']]
  end

  def timeout
    @config['timeout']
  end

  def widths
    @config['screen_widths']
  end

  def domains
    @config['domains'][base_type]
  end

  def base_domain(base_type)
    if base_type =='url'
      domains[base_domain_label]
    else
      comp_domain
    end
  end

  def comp_domain
    domains[comp_domain_label]
  end

  def base_domain_label
    domains.keys[0]
  end

  def comp_domain_label
    domains.keys[1]
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

  def base_browser
    @config['base_browser']
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

  def browser_devices
    if @config.has_key?('browser_devices')
      @config['browser_devices']
    else
      nil
    end
  end

  def spider_file
    @config['spider_file'] ? @config['spider_file'] : 'spider.txt'
  end

  def spider_days
    @config['spider_days']
  end

  def paths
    @config['paths']
  end

  def engine
    @config['engine'][@config['suite']]
  end

  def engine_mode
    mode = @config['engine_mode']
    if mode.nil?
      mode = 'local'
    end
    return mode
  end

  def suites
    @config['suites']
  end

  def suite
    suites[@config['suite']]
  end

  def fuzz
    @config['fuzz']
  end

  def base_type
    @config['base_type']
  end

  def compare_base_to_base
    @config['compare_base_to_base']
  end

  def wait_until_element
    @config['wait_until_element']
  end

  def screenshot_bias
    @config['screenshot_bias']
  end

  def capture_page_image(driver, browser, url, width, file_name)

    if (defined?(driver)) && driver.instance_of?(Selenium::WebDriver::Driver)
      begin
        height = driver.manage.window.size.height
        if height.nil?
          height = 1000
        end
        driver.manage.window.resize_to(width, height)

        new_dimensions = driver.manage.window.size
        new_width = new_dimensions.width
        new_height = new_dimensions.height
        puts "width = " + new_width.to_s
        puts "new_height = " + new_height.to_s
      end
      driver.get(url)
      if width != new_width
        puts "Width error!!! Should be " + width.to_s + " but is " + new_width.to_s
      end
      if wait_until_element
        begin
          wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
          wait.until { driver.find_element(:id => wait_until_element) }
        end
      end
      driver.save_screenshot(file_name)
    else
      command = "#{browser}" + ' ' + "#{@config['options'][@config['suite']]}" + ' ' + "#{snap_file}"  + ' ' + "#{url}" + ' ' + "#{width}" + ' ' + "#{file_name}"
      puts `#{command}`
    end

  end

  def self.crop_images(crop, height)
    # For compatibility with windows file structures switch commenting on the following 2 lines
    puts `convert #{crop} -background none -extent 0x#{height} #{crop}`
    # puts `convert #{crop.gsub('/', '\\')} -background none -extent 0x#{height} #{crop.gsub('/', '\\')}`
  end

  def crop_images(crop, height)
    self.class.crop_images
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

  def get_files_from_array_while_regex(files,regex,regex2)
      remnant = files.dup
      slice = []
      files.each do |file|
         if file.match(regex)
           slice.push(file)
           remnant.shift
         elsif file.match(regex2)
           break
         else
          remnant.shift
         end
      end
      return slice, remnant
  end

  def find_image_dimensions(file,dimensions='all')
      File.open(file, 'rb') do |fh|
        size = ImageSize.new(fh.read).size
        if dimensions == 'all'
          return size
        elsif dimensions == 'width'
          return size[0]
        elsif dimensions == 'height'
          return size[1]
        end
      end
    end
end
