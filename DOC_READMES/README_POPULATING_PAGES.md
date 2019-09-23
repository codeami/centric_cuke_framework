# @markup markdown
# @title Populating pages
The base page class has a populate method that will automagically use the fixture data for the page being populated if it exists in the fixture file.

The populate method has a different signature than the standard populate method in PageObject.  It looks like this:

``` ruby
def populate(data = {}, additional = {})
```

If the _data_ parameter is supplied that data will be used for the page instead of the fixture data. The _additional_ parameter allows you to add/overwrite fixture data to be used.  For example:

```ruby
page.populate({}, { some_page: { first_name: 'fred' } })
```

Will populate the page using the data from the fixture with the exception of the first name.

Since the Centric applications use so many sections, and dialogs using a straight up populate will not usually get you where you need to be.  In those cases you'll want to exercise the UI to get the elements you want to populate visible, the call populate_with yourself.

```ruby
page.show_contacts
page.populate_with cache_data_for :some_page_contact_section
```

### Important
Due to the way data\_magic evaluates macros, calling data_for with the same key at different times can give you different results.  This can make it hard verify that the data was entered correctly. 

Review the README for fixtures for more details.
