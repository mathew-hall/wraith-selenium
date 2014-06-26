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

  def base_type
    wraith.base_type
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
    wraith.base_domain(base_type) + path unless wraith.base_domain(base_type).nil?
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
      screenshot_bias = wraith.screenshot_bias

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
            #calculate the actual width of screenshot buy adding the bias
            width_bias = screenshot_bias['width'][browser][device][width]
            if width_bias.nil?
              width_bias = 0
            end
            width = width + width_bias

            #with url based testing we always take a base shot and comparison shot. The urls are unique in each case
            if wraith.base_type == 'url'
              wraith.capture_page_image driver, browser, base_url, width, base_file_name unless base_url.nil?
              wraith.capture_page_image driver, browser, compare_url, width, compare_file_name unless compare_url.nil?
            #with browser based comparison we take base shot if the current browser is the configured base browser.
            #the urls tested are always identical
            #we can also take a second comparison shot using the base browser if we wish
            #this will be helpful to capture web site instabilities which have nothing to do
            #with cross browser issues
            elsif wraith.base_type == 'browser' && wraith.base_browser == browser && wraith.compare_base_to_base
              wraith.capture_page_image driver, browser, base_url, width, base_file_name unless base_url.nil?
              wraith.capture_page_image driver, browser, compare_url, width, compare_file_name unless compare_url.nil?
            elsif wraith.base_type == 'browser' && wraith.base_browser == browser
              wraith.capture_page_image driver, browser, base_url, width, base_file_name unless base_url.nil?
            #if the comparison type is browser, then any screenshots from a browser that is not the base browser are
            #saved as comparison shots
            elsif wraith.base_type == 'browser'
              wraith.capture_page_image driver, browser, compare_url, width, compare_file_name unless compare_url.nil?
            end
          end

          unless driver.nil?
            quit(driver)
          end
        end
      end
    end
  end
end
