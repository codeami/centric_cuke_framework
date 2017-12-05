module Platforms
  module Watir
    class PageObject

      def root_from_identifier(root_id)
        return @browser if root_id.nil?
        new_root =  self.send(root_id) if root_id.is_a?(Symbol) && self.respond_to?(root_id)
        new_root ||= @browser.send(root_id) if root_id.is_a?(Symbol)

        new_root
      end

      def process_watir_call(the_call, type, identifier, value=nil, tag_name=nil)
        root_object = root_from_identifier identifier.delete(:root)
        identifier, frame_identifiers = parse_identifiers(identifier, type, tag_name)
        value = root_object.instance_eval "#{nested_frames(frame_identifiers)}#{the_call}"
        switch_to_default_content(frame_identifiers)
        value
      end
    end
  end
end
