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

  def engine_mode
    wraith.engine_mode
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

  def file_names(width, label, os, browser, device, domain_label)
    "#{directory}/#{label}/#{width}_#{engine}_#{engine_mode}_#{os}_#{browser}_#{device}_#{domain_label}.png"
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
      engine_mode = wraith.engine_mode

      wraith.suite.each do |browser|

        #if no browser devices specified, assume desktop and create as hash key
        browser_devices = wraith.browser_devices
        if browser_devices.nil?
           browser_devices_for_browser = {'desktop' => ''}
        else
          browser_devices_for_browser = browser_devices[browser]
        end
        browser_devices_for_browser.each_key do |device_or_desktop|
          next unless(os_compatible(browser, device_or_desktop))

          capabilities_array = get_capabilities_array(browser_devices_for_browser[device_or_desktop])

          capabilities_array.each do |capabilities|
            next unless(os_set(engine_mode, capabilities[:os]))

            actual_device = precise_device(device_or_desktop, capabilities[:device])
            next if actual_device.nil?

            capabilities[:url] = get_url(engine_mode, wraith.grid_url, capabilities[:url])
            next unless is_url_properly_set(engine_mode, actual_device, capabilities[:url])

            capabilities[:browser] = browser

            os = os_string(engine_mode, capabilities[:os])

            #can return nil if there is no engine
            driver = return_driver_instance(engine, engine_mode, capabilities, actual_device)

            unless driver.nil?
              set_page_load_timeout(driver,timeout)
            end

            wraith.widths[device_or_desktop].each do |width|

              base_file_name = file_names(width, label, os, browser, actual_device, wraith.base_domain_label)
              compare_file_name = file_names(width, label, os, browser, actual_device, wraith.comp_domain_label)
              #if using selenium, calculate the actual width of screenshot buy adding the bias
              unless driver.nil?
                width_bias = screenshot_bias['width'][browser][device_or_desktop][width]
                if width_bias.nil?
                  width_bias = 0
                end
                width = width + width_bias
              end
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
end
