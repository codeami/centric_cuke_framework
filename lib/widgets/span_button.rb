class SpanButton < PageObject::Elements::Span
  def self.accessor_methods(accessor, name)
    binding.pry;2

    puts 'line'
    accessor.send(:define_method, name) do
      self.send("#{name}_element").click
    end
  end
end
PageObject.register_widget :span_button, SpanButton, :span