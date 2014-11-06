# Configuring Wraith-Selenium

This version of Wraith augments the existing functionality with more options for browser rendering. 

To choose browsers, create at least one `suite` in the `suites` key in your config file. See the `spec/resources/configs` for examples. The original PhantomJS snapshotter can be used by setting the browser to `phantomjs`. Other values correspond to Selenium's browser names (`chrome`,`firefox`,`ie`, `safari`).

Each suite needs an engine to be set, either `""` for PhantomJS (original Wraith behaviour) or "`selenium`" for WebDriver. Selenium Grid is supported by setting the `engine_mode` key to "`grid`" (otherwise, use `local`).

## Comparison Methods

As well as the old site-by-site comparison, this version of Wraith can compare shots between browsers. This behaviour is set by the `base_type` key, either `url` or `browser`.

Each comparison method selects elements from the `domains` key. For browser comparison the `browser:base:` key must be set to the domain to load. You might also need to set the `url:base:` key to any value (the option parser is a little fragile).

Paths are set as normal, by adding them to the `paths` key in the config file.

# Selenium Grid Setup

To use Selenium Grid, a hub needs to be running somewhere, and each host must register its browsers with it. See the [Selenium Documentation](http://docs.seleniumhq.org/docs/07_selenium_grid.jsp) for details of setting up hosts. Note that for IE, the extra [InternetExplorerDriver](https://code.google.com/p/selenium/wiki/InternetExplorerDriver#Required_Configuration) has to be installed and available on the `PATH` somewhere. Additionally, IE needs to be configured to work with WebDriver; the instructions for IEDriver cover the necessary steps.

Once the grid's setup, the config needs to be switched to use the browsers by setting the `engine_mode` to `grid`. Point Wraith at the hub by setting the `grid_url` key.

For Selenium Grid, the capabilities of each browser need to be set, at the very least the platform key. If all your browsers run on one OS, then you can just set the `default_parameters:capabilities:platform` to the Selenium name of the host OS ("MAC","WINDOWS", or "LINUX"). If your hosts run different OSes (typical if you need IE support), then ensure each browser you use has a platform set, either by the default, or separately. For IE, this should be:

	  ie:
	    desktop:
	      - :capabilities:
	          :platform: WINDOWS

# Detecting Page Ready State

By default, Wraith will use a heuristic to guess when the page is ready to be snapshotted. It does this by looking at the window's `readyState` property. If jQuery is loaded, the `$.active` property is also checked.

# Logging In

For pages requiring authentication, Wraith can guess where it's been shown a login screen. If Wraith detects it has been redirected to another domain (typical for most SSO gateways), it will look for login fields if they have been set. The fields, and valid account credentials are set as below:

	credentials:
	  username: my.user.name
	  password: my.password
	  username_field: username
	  password_field: password
	  login_button: submit

The two field values and the button value refer to DOM ids.