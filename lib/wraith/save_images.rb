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

  def file_names(width, label, browser, device, domain_label)
    "#{directory}/#{label}/#{width}_#{engine}_#{browser}_#{device}_#{domain_label}.png"
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

        #if no browser devices specified, assume desktop
        browser_devices = wraith.browser_devices
        if browser_devices.nil?
           browser_devices_for_browser = ['desktop']
        else
          browser_devices_for_browser = browser_devices[browser]
        end
        browser_devices_for_browser.each do |device|

          next unless(os_compatible(browser, device))

          #can return nil if there is no engine
          driver = return_driver_instance(engine, browser, device)

          unless driver.nil?
            set_page_load_timeout(driver,timeout)
          end

          wraith.widths[device].each do |width|

            base_file_name = file_names(width, label, browser, device, wraith.base_domain_label)
            compare_file_name = file_names(width, label, browser, device, wraith.comp_domain_label)

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
end
