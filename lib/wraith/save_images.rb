require 'wraith'
require 'wraith/driver'

class Wraith::SaveImages
  attr_reader :wraith
  include Wraith::Driver

  def initialize(config)
    @wraith = Wraith::Wraith.new(config)
  end

  def directory
    wraith.directory
  end

  def check_paths
    if !wraith.paths
      path = File.read(wraith.spider_file)
      eval(path)
    else
      wraith.paths
    end
  end

  def engine
    wraith.engine
  end

  def timeout
    wraith.timeout
  end

  def base_urls(path)
    wraith.base_domain + path unless wraith.base_domain.nil?
  end

  def compare_urls(path)
    wraith.comp_domain + path unless wraith.comp_domain.nil?
  end

  def file_names(width, label, browser, domain_label)
    "#{directory}/#{label}/#{width}_#{engine}_#{browser}_#{domain_label}.png"
  end

  def save_images
    check_paths.each do |label, path|
      if !path
        path = label 
        label = path.gsub('/', '_') 
      end

      base_url = base_urls(path)
      compare_url = compare_urls(path)

      wraith.suite.each do |browser|

        next unless(os_compatible(browser))

        #can return nil if there is no engine
        driver = return_driver_instance(engine, browser)

        unless driver.nil?
          set_page_load_timeout(driver,timeout)
        end

        wraith.widths.each do |width|

          base_file_name = file_names(width, label, browser, wraith.base_domain_label)
          compare_file_name = file_names(width, label, browser, wraith.comp_domain_label)

          wraith.capture_page_image driver, browser, base_url, width, base_file_name unless base_url.nil?
          wraith.capture_page_image driver, browser, compare_url, width, compare_file_name unless compare_url.nil?

        end

        unless driver.nil?
          quit(driver)
        end
      end
    end
  end
end
