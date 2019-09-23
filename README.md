# Centric Guidewire automation framework

This framework leverages custom extensions to the PageObject gem developed by Centric Consulting to make automation of the Guidewire family of products easier.  These extensions allow us to treat the special Guidewire versions of elements in the same way we'd handle their normal counterparts and to provide convenient interfaces for more complex things such as data grids.

The design philosophy behind this framework is to reduce the complexity of the day-to-day actions of writing tests. The idea is to be able to say "follow this route, with this data, now let me assert something". This means building a lot of intelligence into our page models so that we can hand them a data structure and have them deal with how to get that on the page. Step definitions should not interact with the DOM unless actively testing something about that DOM.

Because of this design philosophy, tests written using this framework must be written in a declarative manner.  When you only need one line of code to create and issue a policy, there's not a lot of point spelling out every step along the way.  This also frees you up to use whatever language you need in your Gherkin to facilitate communication within your team.  There's no harm in dummy steps that do nothing, but convey critical information to human beings.

## Documentation
The subfolder *doc* contains both Yard and human generated documentation.  There are README files for various topics you'll need to understand, to get the most out of this framework. 

Opening *doc/index.html* in your browser will provide easy access to the README files as well as code documentation. **When viewing in your browser, make sure to click on the *files* link in the upper left to see the README files.**
