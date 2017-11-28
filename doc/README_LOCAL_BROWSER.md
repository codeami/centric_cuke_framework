<!--
# @markup markdown
# @title Local Browsers
# 
-->
# Local browser creation in the Centric Framework

Aside from the BROWSER_BRAND variable to determine which local browser to start there are several other configuration options for local browsers.  As with all other ENV variables in the framework you can see the current defaults by looking at *support/lib/nenv.rb*.  It's a good idea to consult this file, as the values in it may have been changed without a documentation update.

## ENV variables for local browsers
The ENV variables below mainly deal with the positioning of the browser window.


| Variable            | Allowed Values                    | Default   | Info                                                                                 |
|---------------------|-----------------------------------|-----------|--------------------------------------------------------------------------------------|
| BROWSER\_BRAND      | chrome, firefox, ie, safari, edge | chrome    | Set to the brand of browser you want to test under.                                  |
| SIZE\_BROWSER       | true/false                        | false     | Should the browser be resized?                                                       |
| BROWSER\_RESOLUTION | NxN                               | 1920x1080 | Used to specify a specific resolution for the browser window.  For example: 1024x768 |
| MOVE\_BROWSER       | true/false                        | false     | Should the browser be moved?                                                         |
| BROWSER\_X          | Any integer                       | 0         | Used to specify the x position for the browser window.                               |
| BROWSER\_Y          | Any integer                       | 0         | Used to specify the y position for the browser window.                               |


## Additional configuration
The config folder contains YAML files for configuring each browser brand.
