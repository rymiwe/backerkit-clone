module Ui
  # @abstract A toast notification component for displaying temporary feedback messages.
  #
  # @example Success notification
  #   <%= render(Ui::ToastComponent.new(message: "Project saved successfully!", type: :success)) %>
  class ToastComponent < ViewComponent::Base
    attr_reader :message, :type, :duration, :dismissible
    
    # Initialize a new toast component
    # @param message [String] the notification message to display
    # @param type [Symbol] the type of notification (:success, :error, :info, :warning)
    # @param duration [Integer] how long the toast should remain visible in milliseconds
    # @param dismissible [Boolean] whether the toast can be manually dismissed
    def initialize(message:, type: :info, duration: 5000, dismissible: true)
      @message = message
      @type = type
      @duration = duration
      @dismissible = dismissible
    end
    
    # @return [String] CSS classes for the toast type
    def type_classes
      case @type
      when :success
        "bg-green-50 border-green-400 text-green-800"
      when :error
        "bg-red-50 border-red-400 text-red-800"
      when :warning
        "bg-yellow-50 border-yellow-400 text-yellow-800"
      when :info
        "bg-blue-50 border-blue-400 text-blue-800"
      else
        "bg-gray-50 border-gray-400 text-gray-800"
      end
    end
    
    # @return [String] icon to display based on type
    def icon_path
      case @type
      when :success
        "M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
      when :error
        "M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
      when :warning
        "M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
      when :info
        "M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
      else
        "M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
      end
    end
  end
end
