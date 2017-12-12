# frozen_string_literal: true

class SpanButton < PageObject::Elements::Span
  def self.accessor_methods(accessor, name)
    accessor.send(:define_method, name) do
      send("#{name}_element").click
    end
  end
end
PageObject.register_widget :span_button, SpanButton, :span
