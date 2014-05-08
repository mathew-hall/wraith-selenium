require "selenium-webdriver"

module Wraith::Driver

  def return_driver_instance(engine, browser)
    if (defined?(engine)).nil?
      return nil
    elsif engine.eql?("selenium") && browser.eql?("chrome")
      return Selenium::WebDriver.for :chrome
    elsif engine.eql?("selenium") && browser.eql?("safari")
      return Selenium::WebDriver.for :safari
    elsif engine.eql?("selenium") && browser.eql?("firefox")
      return Selenium::WebDriver.for :firefox
    elsif engine.eql?("selenium") && browser.eql?("ie")
      return Selenium::WebDriver.for :ie
    elsif engine.eql?("selenium") && browser.eql?("android")
      return Selenium::WebDriver.for :remote, :desired_capabilities => :android
    end
  end

  def command

  end

  def quit(driver)
    unless (defined?(engine)).nil?
      driver.quit
    end
  end

  def os_compatible(browser)
    if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil? && browser.eql?("ie")
      puts "Sorry, you can not run Internet Explorer on this OS"
      return false
    end
      return true
  end
  def set_page_load_timeout(driver, timeout)
    puts driver.capabilities.browser_name
    unless driver.capabilities.browser_name =~ /selendroid|safari/
      driver.manage.timeouts.page_load = timeout
    end
  end
end