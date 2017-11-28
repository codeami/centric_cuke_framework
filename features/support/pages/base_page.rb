# frozen_string_literal: true
require 'page-object'
require 'data_magic'

class BasePage
  include PageObject
  include DataMagic
  include PageFactory
end
