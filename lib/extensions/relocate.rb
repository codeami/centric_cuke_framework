# frozen_string_literal: true

# Extend Watir to add a relocate method.  This can be used to get around cached elements
module Watir
  class Element
    # Forces the element to be relocated
    def relocate
      @element = locate
      self
    end
  end
end
