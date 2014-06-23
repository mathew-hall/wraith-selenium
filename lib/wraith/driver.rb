require 'selenium-webdriver'

module Wraith::Driver

  def return_driver_instance(engine, browser, device)
    if (defined?(engine)).nil?
      nil
    end
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

  def quit(driver)
    unless (defined?(engine)).nil?
      driver.quit
    end
  end

  def os_compatible(browser, device)
    if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil? && device == 'desktop' && browser.eql?('ie')
      puts 'Sorry, you can not run Internet Explorer on this OS'
      return false
    elsif device == 'desktop' && browser == 'android'
      puts 'Sorry, you can not run ' + browser + ' on ' + device + '.'
      return false
    end
      true
  end
  def set_page_load_timeout(driver, timeout)
    unless driver.capabilities.browser_name =~ /selendroid|safari|android|iPad|iPhone/
      driver.manage.timeouts.page_load = timeout
    end
  end
end