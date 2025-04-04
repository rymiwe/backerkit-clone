module Ui
  # @abstract A component for displaying form labels with consistent styling and accessibility
  #
  # @example Basic usage
  #   <%= render(Ui::FormLabelComponent.new(form: form, field: :title, label_text: "Project Title")) %>
  class FormLabelComponent < ViewComponent::Base
    attr_reader :form, :field, :label_text, :required, :errors
    
    # Initialize a new form label component
    # @param form [ActionView::Helpers::FormBuilder] The form object
    # @param field [Symbol] The field name
    # @param label_text [String] The text to display in the label (optional, will use humanized field name if not provided)
    # @param required [Boolean] Whether the field is required
    def initialize(form:, field:, label_text: nil, required: false)
      @form = form
      @field = field
      @label_text = label_text || field.to_s.humanize
      @required = required
      @errors = form.object.errors if form.object.respond_to?(:errors)
    end
    
    # @return [Boolean] Whether the field has any errors
    def error?
      errors && errors.include?(field)
    end
    
    # @return [String] CSS classes for the label
    def label_classes
      base_classes = "block text-sm font-medium mb-1"
      error? ? "#{base_classes} text-red-600" : "#{base_classes} text-gray-700"
    end
    
    # @return [String] A unique ID for the input field
    def input_id
      "#{form.object_name}_#{field}"
    end
    
    # @return [String] A unique ID for the error element
    def error_id
      "error_#{form.object_name}_#{field}"
    end
  end
end
