require 'selenium-webdriver'

module Wraith::Driver
  #will return the parameters listed or will create an array containing an empty hash
  def get_parameters_array(capabilities_array)
    if capabilities_array.nil? || capabilities_array.length == 0
      new_array = []
      new_array[0] = wraith.default_parameters
      return new_array
    end
    return capabilities_array
  end

  def set_url(engine_mode,selenium_grid_url,capabilities_url)
    if engine_mode == 'grid'
      selenium_grid_url
    else
      capabilities_url
    end
  end

  def set_browser_name(device_or_desktop,browser,precise_device)
    if device_or_desktop == 'desktop'
      browser
    else
      precise_device
    end
  end

  def return_driver_instance(engine, engine_mode, parameters, device)
    if (defined?(engine)).nil? || engine.nil?
      return nil
    elsif engine_mode =='local' && device == 'desktop'
      return Selenium::WebDriver.for parameters[:capabilities][:browser_name].to_sym
    else
      return Selenium::WebDriver.for :remote, :desired_capabilities => parameters[:capabilities], :url => parameters[:url]
    end
  end

  def quit(driver)
    unless (defined?(engine)).nil?
      driver.quit
    end
  end

  # shamelessly nicked from Stackoverflow:
  # http://stackoverflow.com/questions/170956/how-can-i-find-which-operating-system-my-ruby-program-is-running-on
  def windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def unix?
    windows?
  end

  def linux?
    unix? and not mac?
  end

  #returns the remote os if one defined for grid or locally attached device
  #if running locally then finds the local os and returns as string
  def os_string(engine_mode, device_or_desktop, remote_os)
    if engine_mode == 'grid' || device_or_desktop == 'device'
      return remote_os.to_s
    elsif windows?
      return 'windows'
    elsif mac?
      return 'mac'
    elsif linux?
      return 'linux'
    elsif unix?
      return 'unix'
    end
  end

  def os_compatible(browser, device)
    if !windows? && device == 'desktop' && browser.eql?('ie')
      puts 'Sorry, you can not run Internet Explorer on this OS'
      return false
    elsif device == 'desktop' && browser == 'android'
      puts 'Sorry, you can not run ' + browser + ' on ' + device + '.'
      return false
    end
      true
  end

  def is_url_set(engine_mode, actual_device, url)
    #no url is needed when running locally on desktop
    if engine_mode == 'local' && actual_device == 'desktop'
      return true
    elsif url.nil?
    puts 'The device or grid url is not set. Ignoring'
      return false
    end
    return true
  end

  def is_os_set(engine_mode, device_or_desktop, remote_os)
    if (engine_mode == 'grid' || device_or_desktop == 'device') && remote_os.nil?
      puts 'You MUST define the remote os when using Selenium Grid or a remote device. Ignoring.'
      false
    else
      true
    end
  end

  def is_precise_device_set(precise_device)
    if precise_device.nil?
      puts 'If running on a device, you must configure the actual device (iPad / iPhone, etc) you are running on. Ignoring'
      return false
    end
    return true
  end

  def is_browser_name_set(browser_name)
      if browser_name.nil?
        puts 'You must properly configure your browser name. Ignoring'
        return false
      end
      return true
  end

  #will always return 'Desktop' as the generic type unless running on a device
  #in which case gets the specific device defined in the parameters in the config
  #used for file name
  def set_precise_device(desktop_or_device, precise_device)
    if desktop_or_device == 'desktop'
      return desktop_or_device
    end
    return precise_device
  end

  def set_page_load_timeout(driver, timeout)
    unless driver.capabilities.browser_name =~ /selendroid|safari|android|iPad|iPhone/
      driver.manage.timeouts.page_load = timeout
    end
  end
end