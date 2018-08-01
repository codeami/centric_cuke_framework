# frozen_string_literal: true

## Helper module for loading, merging and saving fixture files
# Uses the Yaml include monkey patch.
module Helpers
  module Fixtures
    # The fixture helper will automatically load fixtures for scenarios
    # based on their tags. A fixture tag is a tag prefixed with @fixture_
    # anything after the underscore will be used as the basename for
    # the fixture you want loaded.
    #
    # Fixture files are loaded using a "basename", this base name is used
    # in a MagicPath and resolved to an actual path. There are two MagicPaths
    # for fixture file names: fixture_file_base and fixture_file_env
    #
    # **fixture_file_base** defines a default fixture file. A basename of
    # 'foo' would resolve to 'foo.yml' using the default fixture_file_base
    #
    # **fixture_file_env defines** a fixture file for a specific test environment.
    # it combines the environment variable TEST_ENV with the base name.
    # For example, a TEST_ENV of 'staging' and a basename of 'foo' will
    # resolve to 'foo.staging.yml'.
    #
    # When the helper loads files, it first tries to load the enviroment
    # specific fixture file. This allows us to customize fixture data
    # for specific environments and fall back on a default for all others.
    #
    # All of the above refers to the default paths for fixture files.
    # However, since they're MagicPaths and intended to be customized
    # they may resolve to different values based on how they're configured.
    #
    # Refer to support/paths.rb for the current patterns for those two paths.
    #
    # The environment variable FIXTURE_ROOT is used as the default location
    # for fixture files. It's default value can be found in lib/nenv_vars.rb
    #

    # Given a scenario, load any fixture it needs.
    # Fixture tags should be in the form of @fixture_FIXTUREFILE
    #
    # @param scenario [Scenario]
    # @param fixture_folder [String] Where to find fixture files
    def self.load_fixtures_for(scenario, fixture_folder = Nenv.fixture_root)
      DataMagic.yml_directory = fixture_folder
      fixture_files           = fixture_files_on(scenario)
      STDERR.puts "Found #{fixture_files.count} fixtures on scenario.  Using #{fixture_files.last}." if fixture_files.count > 1
      load_fixture(fixture_files.last) if fixture_files.count.positive?
    end

    # Load a fixture file by name, returns a hash of the data
    #
    # @param base_name [String] The name of the fixture file to load.
    # @param fixture_folder [String] Where to find fixture files
    def self.load_fixture(base_name, fixture_folder = Nenv.fixture_root)
      DataMagic.yml_directory = fixture_folder
      DataMagic.load actual_fixture_path(base_name)
    end


    # Given a fixture file base name, resolve it's full path
    # this will first look for files using the fixture_file_env magic path
    # if that's missing it will try the fixture_file_base magic path.
    #
    # @param base_name [String] The name of the fixture file to find.
    #
    # @return [String] The full path the fixture file.
    def self.actual_fixture_path(base_name)
      data = { filename: File.basename(base_name, '.yml'), ext: '.yml' }
      FIXTURE_FILE_PATTERNS.each do |type|
        path = MagicPath.send(type).resolve(data)
        return path if File.exist? "#{MagicPath.fixture_path}/#{path}"
      end
      raise "Could not find fixture to match #{base_name}"
    end

    # Given a hash save it as a fixture.
    # Files are saved to Nenv.fixture_root
    #
    # @param name [String] The basename for the file
    # @param data [Hash] The data to save in the fixture file
    # @param fixture_folder [String] Where to save it.
    def self.save_fixture(name, data, fixture_folder = Nenv.fixture_root)
      File.open("#{fixture_folder}/#{name}.yml", 'w') { |yf| YAML.dump(data, yf) }
    end

    # Load a fixture and merge it with an existing hash
    # Performs a deep merge so nested hashes are merged as well.
    #
    # @param fixture_name [String] The basename for the fixture to load
    # @param base_hash [Hash] The data to merge the fixture file with.
    # @param fixture_folder [String] Where to save it.
    def self.load_fixture_and_merge_with(fixture_name, base_hash, fixture_folder = Nenv.fixture_root)
      new_hash = load_fixture(fixture_name, fixture_folder)
      base_hash.deep_merge new_hash
    end

    # Given a cucumber scenario locate any tags for fixture files.
    #
    # @param scenario [Scenario] A cucumber scenario
    #
    # @return [Array] The list of fixture tags
    def self.fixture_tags_on(scenario)
      # tags for cuke 2, source_tags for cuke 1
      tags = scenario.send(scenario.respond_to?(:tags) ? :tags : :source_tags)
      tags.map(&:name).select { |t| t =~ /@fixture_/ }
    end

    # Remap the output of fixture_tags_on into fixture base names
    #
    # @param scenario [Scenario] A cucumber scenario
    #
    # @return [Array] The list of fixture file base names
    def self.fixture_files_on(scenario)
      fixture_tags_on(scenario).map { |t| t.gsub('@fixture_', '') }
    end
  end
end
