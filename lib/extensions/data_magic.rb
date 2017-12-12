# frozen_string_literal: true

## DataMagic namespace for monkey patching
module DataMagic
  ##
  # :category: extensions
  #
  # Works like the existing data_for but instead of blowing up if the key is missing returns the data found in +default+
  def data_for_or_default(key, default = {}, additional = {})
    if key.is_a?(String) && key.match(%r{/})
      filename, record = key.split('/')
      DataMagic.load("#{filename}.yml")
    else
      record = key.to_s
      DataMagic.load(the_file) unless DataMagic.yml
    end

    data = DataMagic.yml[record]
    data ||= default.dup
    additional.key?(record) ? prep_data(data.merge(additional[record]).clone) : prep_data(data)
  end
end
