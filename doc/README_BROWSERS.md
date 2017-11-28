<!--
# @markup markdown
# @title Browser Creation
# 
-->
# Browser creation in the Centric Framework

Browser creation is handled by the Helpers::Browser object located in lib/helpers/browser.rb. The type of browser created is controlled by environment variables which we'll go over below.

## General Browser Creation

### Step one: Pick a browser type

The ENV variable BROWSER_TYPE determines the type of browser to create.  It can hold the following values:

* local (default) - Creates a browser on the local machine using Chromedriver or the like. See README\_LOCAL\_BROWSER.md for details on configuring a local browser.
* sauce - Creates a browser using the Sauce Labs API. See README\_SAUCE\_LABS.md for details on configuring a Sauce Labs browser.
* selenium_hub - Creates a browser using a Selenium hub. See README\_SELENIUM\_HUB.md for details on configuring Selenum Hub browsers.

Depending on the value, additional ENV variables come into play.  Make sure to review the README files for the various browser types to see available configuration options.

Additional browser types can be added by implementing a *create\_TYPE\_browser* function within Helpers::Browser.

### Step Two: Pick a browser brand
The ENV variable BROWSER_BRAND selects between chrome, Firefox, etc.  Its value should contain a string that's recognized by your browser_type.

For all current browser types this variable can contain the following values:

* chrome (default)
* firefox
* ie
* safari

### Step Three: Create your browser
Calling Helpers::Browser.create_browser will create the appropriate browser based on your ENV variables.  For normal usage this is handled for you by the hooks.



