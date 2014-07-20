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

  def file_names(width, label, os, browser, version, device, domain_label)
    "#{directory}/#{label}/#{width}_#{engine}_#{engine_mode}_#{device}_#{browser}_#{domain_label}.png"
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
          next unless(os_compatible(browser, engine_mode, device_or_desktop))

          parameters_array = get_parameters_array(browser_devices_for_browser[device_or_desktop])

          parameters_array.each do |parameters|
            next unless(is_os_set(engine_mode, device_or_desktop, parameters[:capabilities][:platform]))
            os_name = os_string(engine_mode, device_or_desktop, parameters[:capabilities][:platform])

            precise_device = set_precise_device(device_or_desktop, parameters[:actual_device])
            next unless is_precise_device_set(precise_device)

            parameters[:url] = set_url(engine_mode, wraith.grid_url, parameters[:url])
            next unless is_url_set(engine_mode, precise_device, parameters[:url])

            parameters[:capabilities][:browser_name] = set_browser_name(device_or_desktop,browser,precise_device)
            next unless is_browser_name_set(parameters[:capabilities][:browser_name])

            browser_version = parameters[:capabilities][:version]
            #can return nil if there is no engine
            driver = return_driver_instance(engine, engine_mode, parameters, precise_device)

            unless driver.nil?
              set_page_load_timeout(driver,timeout)
            end

            wraith.screen_properties[device_or_desktop].each do |props|

              props_hash = Hash.new
              if props.is_a?(Hash)
                #we already have set properties, so just transfer
                props.each_key do |key|
                  props_hash[key] = props[key]
                end
              else
                #we just have a configured width for our screen properties, so create a hash structure
                props_hash[:dimensions] = [props,wraith.default_screen_height]
                props_hash[:name] = props
              end

              base_file_name = file_names(props_hash[:name], label, os_name, browser, browser_version, precise_device, wraith.base_domain_label)
              compare_file_name = file_names(props_hash[:name], label, os_name, browser, browser_version, precise_device, wraith.comp_domain_label)
              #if using selenium, calculate the actual width of screenshot buy adding the bias
              unless driver.nil?
                width_bias = screenshot_bias['width'][browser][device_or_desktop][props_hash[:dimensions][0]]
                if width_bias.nil?
                  width_bias = 0
                end
                props_hash[:dimensions][0] = props_hash[:dimensions][0] + width_bias
              end

              #with url based testing we always take a base shot and comparison shot. The urls are unique in each case
              if wraith.base_type == 'url'
                wraith.capture_page_image driver, browser, base_url, props_hash, base_file_name unless base_url.nil?
                wraith.capture_page_image driver, browser, compare_url, props_hash, compare_file_name unless compare_url.nil?
              #with browser based comparison we take base shot if the current browser is the configured base browser.
              #the urls tested are always identical
              #we can also take a second comparison shot using the base browser if we wish
              #this will be helpful to capture web site instabilities which have nothing to do
              #with cross browser issues
              elsif wraith.base_type == 'browser' && wraith.base_browser == browser && wraith.compare_base_to_base
                wraith.capture_page_image driver, browser, base_url, props_hash, base_file_name unless base_url.nil?
                wraith.capture_page_image driver, browser, compare_url, props_hash, compare_file_name unless compare_url.nil?
              elsif wraith.base_type == 'browser' && wraith.base_browser == browser
                wraith.capture_page_image driver, browser, base_url, props_hash, base_file_name unless base_url.nil?
              #if the comparison type is browser, then any screenshots from a browser that is not the base browser are
              #saved as comparison shots
              elsif wraith.base_type == 'browser'
                wraith.capture_page_image driver, browser, compare_url, props_hash, compare_file_name unless compare_url.nil?
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
