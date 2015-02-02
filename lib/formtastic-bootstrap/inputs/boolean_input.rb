# TODO See if this can be refactored to make use of some of the Choices code.
module FormtasticBootstrap
  module Inputs
    class BooleanInput < Formtastic::Inputs::BooleanInput
      include Base

      def to_html
        input_wrapping do
          hidden_field_html <<
          label_with_nested_checkbox
        end
      end

      def hidden_field_html
        template.hidden_field_tag(input_html_options[:name], unchecked_value, :id => nil, :disabled => input_html_options[:disabled] )
      end

      def label_with_nested_checkbox
        builder.label(
          method,
          label_text_with_embedded_checkbox,
          label_html_options
        )
      end

      def label_html_options
        {
          :for => input_html_options[:id],
          :class => super[:class] - ['label'] # remove 'label' class
        }
      end

      def label_text_with_embedded_checkbox
        check_box_html << "" << label_text
      end

      def check_box_html
        template.check_box_tag("#{object_name}[#{method}]", checked_value, checked?, input_html_options)
      end

      def unchecked_value
        options[:unchecked_value] || '0'
      end

      def checked_value
        options[:checked_value] || '1'
      end

      def responds_to_global_required?
        false
      end

      def input_html_options
        {:name => input_html_options_name}.merge(super)
      end

      def input_html_options_name
        if builder.options.key?(:index)
          "#{object_name}[#{builder.options[:index]}][#{method}]"
        else
          "#{object_name}[#{method}]"
        end
      end

      def checked?
        object && boolean_checked?(object.send(method), checked_value)
      end

      private

      def boolean_checked?(value, checked_value)
        case value
        when TrueClass, FalseClass
          value
        when NilClass
          false
        when Integer
          value == checked_value.to_i
        when String
          value == checked_value
        when Array
          value.include?(checked_value)
        else
          value.to_i != 0
        end
      end
    end
  end
end
