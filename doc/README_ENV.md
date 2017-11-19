<!--
# @markup markdown
# @title Environment variables in the Centric framework.
# 
-->
# Environment variables in the Centric framework.

## Nenv
**[Nenv](https://rubygems.org/gems/nenv)** simplifies dealing with environment variables. It provides a clean syntax where env keys become methods. You no longer need to worry about the case of the keys and there's automatic boolean conversion that handles true/false/0/1.

It's *highly* recommended to review the README for Nenv to get a feel for what's posible.


## Standards
 * Any environment variable that requires complex logic, or a default value must have an Nenv method in *support/lib/nenv.rb*.
 * Default values for environment variable methods must have a constant declared at the top of *support/lib/nenv.rb*.  Do NOT add magic values to the Nenv methods.

## Environment variables used by the framework
 The table below lists the various environment variables that can be used to tune the behavior of the framework.  Many of these are exposed as profiles. 

| Variable               | Allowed Values                      | Required                      | Default                              | Info                                                                                                   |
|------------------------|-------------------------------------|-------------------------------|--------------------------------------|--------------------------------------------------------------------------------------------------------|
| CONFIG\_PATH           | A path relative to the project root |                               | ./config                             | Where should the config helper look for files.                                                         |
| TEST\_ENV              | Freeform                            |                               |                                      | Used to differentiate which environment you're running in.                                             |
| TEST\_ENV\_NUMBER      | Any integer                         |                               |                                      | Used for differentiating between children when running tests in parallel.                              |
| SERVER_HOSTNAME        | String                              |                               | Loaded from config based on test env | Used for building URLs to the system under test.                                                       |
| CUKE\_DEBUG            | true/false                          |                               | false                                | If set to true, a pry session will be opened when a test fails.                                        |
| CUKE\_ENV\_DEBUG       | true/false                          |                               | false                                | If set to true, a pry session will be opened eat the end of env.rb                                     |
| CUKE\_STEP\_SIZE       | Any integer                         |                               | 0                                    | If set to a non-zero value, test execution will stop and wait for a keypress.  Useful for doing demos. |
| BROWSER\_TYPE          | local, remote                       |                               | local                                | Set to local to use browsers via your local machine.   Set to remote to use browsers via sauce labs.   |
| BROWSER\_BRAND         | chrome, firefox, ie, safari, edge   |                               | chrome                               | Set to the brand of browser you want to test under.                                                    |
| BROWSER\_RESOLUTION    | NxN                                 |                               | 1920x1080                            | Used to specify a specific resolution for the browser window.  For example: 1024x768                   |
| BROWSER\_X             | Any integer                         |                               | 0                                    | Used to specify the x position for the browser window.                                                 |
| BROWSER\_Y             | Any integer                         |                               | 0                                    | Used to specify the y position for the browser window.                                                 |
| SAUCE\_VERSION         |                                     | When BROWSER\_TYPE == remote. |                                      |                                                                                                        |
| SAUCE\_PLATFORM        |                                     | When BROWSER\_TYPE == remote. |                                      |                                                                                                        |
| SAUCE\_CLIENT\_TIMEOUT | Any integer                         |                               | 180                                  | How long should Sauce Labs API calls be allowed to run?                                                |