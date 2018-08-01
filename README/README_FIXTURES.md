# @markup markdown
# @title Fixtures in the Centric framework

* Fixtures within the Centric framework use the [DataMagic gem](https://github.com/cheezy/data_magic) to do the heavy lifting. 
* Fixtures are located in the folder features/support/fixtures and should be given a meaningful name.  Either the name of the scenario/feature or the card number from the automation scrum board if available.
* Most pages support population from fixtures, provided that the fixture file has a key that corresponds to the page class name in snake case.   For example MyCoolPage would be my\_cool_page.
* Fixtures are automatically loaded by the framework if a fixture tag is provided.  @fixture_as_32 would load the YAML file as_32.yml in the fixtures folder.

## DataMagic translators
The Centric framework defines some additional translators for DataMagic:

* time_name - Creates a name with a timestamp attached to ensure uniqueness. For example ~time_name('foo') would generate a name that looks like "foo <timestamp down to the ms>"
* company_type - Generates a random company type that's valid for creating a company.

### Working with dynamic names
Each time you call data\_for, the translators are run again.  This can be a major problem if your fixture includes translators.  

* Pages should use the method cache\_data\_for instead of data\_for when populating.  This method will update a cache with the last generated values.
* Stepdefs that need to refer back to the generated data should use the DataForCache like so:

```ruby
# Populating
populate_page_with cache_data_for 'my_page'

# Validating later
data_used = DataForCache['my_page']
```

