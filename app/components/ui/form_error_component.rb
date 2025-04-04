module Ui
  # @abstract A component for displaying form errors in a consistent, accessible way
  #
  # @example Basic usage
  #   <%= render(Ui::FormErrorComponent.new(errors: @project.errors, field: :title)) %>
  class FormErrorComponent < ViewComponent::Base
    attr_reader :errors, :field
    
    # Initialize a new form error component
    # @param errors [ActiveModel::Errors] The errors object from a model
    # @param field [Symbol] The field name to display errors for
    def initialize(errors:, field:)
      @errors = errors
      @field = field
    end
    
    # @return [Boolean] Whether the field has any errors
    def error?
      errors.include?(field)
    end
    
    # @return [Array<String>] The error messages for the field
    def error_messages
      errors.full_messages_for(field)
    end
    
    # @return [String] A unique ID for the error element to be referenced by aria-describedby
    def error_id
      "error_#{field}"
    end
  end
end
