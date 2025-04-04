module Ui
  # @abstract A standardized modal component that can be used throughout the application
  # for consistent styling and accessibility features.
  #
  # @example Basic usage
  #   <%= render(Ui::ModalComponent.new(id: "my-modal", title: "Settings")) do %>
  #     <p>Modal content here</p>
  #   <% end %>
  class ModalComponent < ViewComponent::Base
    attr_reader :id, :title, :size, :close_button

    # Initialize a new modal component
    # @param id [String] unique ID for the modal (required for proper Stimulus controller functioning)
    # @param title [String] title displayed in the modal header
    # @param size [Symbol] size of the modal (:sm, :md, :lg, :xl)
    # @param close_button [Boolean] whether to show the close button in the header
    def initialize(id:, title: nil, size: :md, close_button: true)
      @id = id
      @title = title
      @size = size
      @close_button = close_button
    end
    
    # @return [String] CSS classes for the modal size
    def size_classes
      case @size
      when :sm
        "max-w-sm"
      when :md
        "max-w-md"
      when :lg
        "max-w-lg"
      when :xl
        "max-w-xl"
      when :full
        "max-w-4xl"
      else
        "max-w-md"
      end
    end
  end
end
