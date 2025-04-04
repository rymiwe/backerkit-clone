module Ui
  class ProgressBarComponent < ViewComponent::Base
    attr_reader :percentage, :height, :color, :background_color, :text_display
    
    def initialize(percentage:, height: 2, color: "indigo-600", background_color: "gray-200", text_display: nil)
      @percentage = percentage || 0
      @height = height
      @color = color
      @background_color = background_color
      @text_display = text_display
    end
    
    def color_class
      "bg-#{color}"
    end
    
    def background_class
      "bg-#{background_color}"
    end
    
    def height_class
      "h-#{height}"
    end
    
    def display_text?
      text_display.present?
    end
  end
end
