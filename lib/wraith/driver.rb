require 'selenium-webdriver'

module Wraith::Driver
  #will return the capabilities listed or will create an array containing an empty hash
  def get_capabilities_array(capabilities_array)
    if capabilities_array.nil? || capabilities_array.length == 0
      new_array = []
      new_array[0] = Hash.new()
      return new_array
    end
    return capabilities_array
  end

  def get_url(engine_mode,selenium_grid_url,capabilities_url)
    if engine_mode == 'grid'
      selenium_grid_url
    else
      capabilities_url
    end
  end

  def is_url_properly_set(engine_mode, actual_device, url)
    #no url is needed when running locally on desktop
    if engine_mode == 'local' && actual_device == 'desktop'
      return true
    elsif url.nil?
    puts 'The device or grid url is not set. Ignoring'
      return false
    end
    return true
  end

  def return_driver_instance(engine, engine_mode, capabilities, device)
    if (defined?(engine)).nil?
      nil
    end
    if engine_mode == 'local'
      if device == 'desktop'
        if engine.eql?('selenium') && browser.eql?('chrome')
          return Selenium::WebDriver.for :chrome
        elsif engine.eql?('selenium') && browser.eql?('safari')
          return Selenium::WebDriver.for :safari
        elsif engine.eql?('selenium') && browser.eql?('firefox')
          return Selenium::WebDriver.for :firefox
        elsif engine.eql?('selenium') && browser.eql?('ie')
          return Selenium::WebDriver.for :ie
        elsif engine.eql?('selenium') && browser.eql?('opera')
          return Selenium::WebDriver.for :opera
        end
      elsif device == 'device'
        if engine.eql?('selenium') && browser.eql?('android')
          return Selenium::WebDriver.for :remote, :desired_capabilities => :android, :url => 'http://localhost:4444/wd/hub/'
        elsif engine.eql?('selenium') && browser.eql?('chrome')
          return Selenium::WebDriver.for :remote, :desired_capabilities => :chrome
        elsif engine.eql?('selenium') && browser.eql?('firefox')
          return Selenium::WebDriver.for :remote, :desired_capabilities => :firefox
        elsif engine.eql?('selenium') && browser.eql?('ie')
          return Selenium::WebDriver.for :remote, :desired_capabilities => :ie
        elsif engine.eql?('selenium') && browser.eql?('safari')
          return Selenium::WebDriver.for :remote, :desired_capabilities => :ipad, :url => 'http://<DEVICE IP>:3001/wd/hub/'
        end
      end
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

  #returns the remote os if one defined for grid
  #if running locally then finds the local os and returns as string
  def os_string(engine_mode,remote_os)
    if engine_mode == 'grid'
      return remote_os
    elsif windows?
      return 'Windows'
    elsif mac?
      return 'Mac'
    elsif linux?
      return 'Linux'
    elsif unix?
      return 'Unix'
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

  def os_set(engine_mode, remote_os)
    if engine_mode == 'grid' && remote_os.nil?
      puts 'You MUST define the remote os when using Selenium Grid. Ignoring.'
      false
    else
      true
    end
  end

  #will always return 'Desktop' is this the generic device type
  #will otherwise get the specific device defined in the capability
  #used for file name
  def precise_device(desktop_or_device, precise_device)
    if desktop_or_device == 'Desktop'
      return desktop_or_device
    elsif precise_device.nil?
      puts 'You must configure the precise device type. Ignoring.'
    end
    return precise_device
  end

  def set_page_load_timeout(driver, timeout)
    unless driver.capabilities.browser_name =~ /selendroid|safari|android|iPad|iPhone/
      driver.manage.timeouts.page_load = timeout
    end
  end
end