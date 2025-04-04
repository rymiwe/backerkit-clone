module Ui
  # @abstract A standardized progress bar component for visualizing completion percentages
  #
  # @example Basic usage
  #   <%= render(Ui::ProgressBarComponent.new(percentage: 65)) %>
  #
  # @example With custom height and color
  #   <%= render(Ui::ProgressBarComponent.new(percentage: 75, height: "lg", color: "indigo-600")) %>
  class ProgressBarComponent < ViewComponent::Base
    attr_reader :percentage, :height, :color, :background_color, :text_display
    
    def initialize(percentage:, height: "sm", color: "indigo-600", background_color: "gray-200", text_display: nil)
      @percentage = percentage || 0
      @height = height
      @color = color
      @background_color = background_color
      @text_display = text_display
    end
    
    # @return [String] CSS class for the progress bar height
    def height_class
      case height.to_s
      when "xs", "extra-small"
        "progress-bar--xs"
      when "sm", "small"
        "progress-bar--sm"
      when "md", "medium"
        "progress-bar--md"
      when "lg", "large"
        "progress-bar--lg"
      else
        if height.to_s.match?(/^\d+$/)
          "h-#{height}" # For backward compatibility with numeric heights
        else
          "progress-bar--sm" # Default
        end
      end
    end
    
    # @return [String] CSS class for the progress bar color
    def color_class
      if color.include?("-")
        "bg-#{color}" # For Tailwind colors like "indigo-600"
      else
        color # For custom colors
      end
    end
    
    # @return [String] CSS class for the background color
    def background_class
      if background_color.include?("-")
        "bg-#{background_color}" # For Tailwind colors
      else
        background_color # For custom colors
      end
    end
    
    # @return [Boolean] Whether to display text with the progress bar
    def display_text?
      text_display.present?
    end
  end
end
