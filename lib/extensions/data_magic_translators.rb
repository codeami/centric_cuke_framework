# frozen_string_literal: true

module ServPro
  def time_name(prefix = 'Automation')
    "#{prefix}#{Time.now.strftime '%Y%m%d%H%M%S%L'}"
  end

  COMPANY_TYPES = ['Unknown', 'Association', 'Building Maintenance', 'Business, Professional', 'Business, Retail',
                   'Church', 'Educational Facility', 'Arts/Entertainment/Leisure Facility', 'Flooring/Furniture Provider',
                   'General Contractor/Builder', 'Government Facility/Municipality', 'Home/Building Inspection Service',
                   'Home/Business Repair Professional', 'Insurance Professional', 'Land Subdivider/Developer',
                   'Lodging/Hospitality Management', 'Medical Facility', 'Plumber/HVAC',
                   'Property Management', 'Real Estate Agent/Manager', 'Restaurant/Dining', 'Roofer',
                   'Title Abstract Office', 'Title Insurance', 'Transportation Provider',
                   'Subcontractor'].freeze
  def company_type
    COMPANY_TYPES[rand(COMPANY_TYPES.count - 1)]
  end

  # Generate a unique email address that's compatible with gmail
  # it works by appending '+' and a timestamp to the username
  # portion of the email address.  Gmail will ignore everything after
  # the '+' and deliver the email.
  #
  # This allows us to have one-time email addresses that all map back
  # to the same common email account.
  #
  # @param name [String] The name portion of the email address
  # @param domain [String]
  def unique_email(name, domain)
    "#{name}+#{Time.now.strftime '%Y%m%d%H%M'}@#{domain}"
  end
end
DataMagic.add_translator ServPro # this line must go in the same file as the module
