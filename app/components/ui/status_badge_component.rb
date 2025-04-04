module Ui
  class StatusBadgeComponent < ViewComponent::Base
    attr_reader :status, :text, :progress
    
    def initialize(status:, text: nil, progress: nil)
      @status = status.to_s.gsub('_', '-')
      @text = text || status.to_s.titleize
      @progress = progress
    end
    
    def badge_class
      base_class = "status-badge"
      status_class = case status.to_sym
      when :not_started, :"not-started"
        "status-badge-not-started"
      when :in_progress, :"in-progress", :in_production, :"in-production"
        "status-badge-in-progress"
      when :in_transit, :"in-transit"
        "status-badge-in-transit"
      when :shipping_soon, :"shipping-soon"
        "status-badge-shipping-soon"
      when :awaiting_shipping, :"awaiting-shipping", :shipping, :"shipping"
        "status-badge-awaiting-shipping"
      when :shipped, :"shipped", :completed, :"completed"
        "status-badge-completed"
      else
        "status-badge-not-started"
      end

      "#{base_class} #{status_class}"
    end
    
    def progress_percentage
      return 0 if progress.nil?
      [[progress.to_i, 0].max, 100].min
    end
    
    def progress_color
      case status.to_sym
      when :not_started, :"not-started"
        "gray-400"
      when :in_progress, :"in-progress", :in_production, :"in-production"
        "blue-500"
      when :in_transit, :"in-transit"
        "indigo-500"
      when :shipping_soon, :"shipping-soon"
        "purple-500"
      when :awaiting_shipping, :"awaiting-shipping", :shipping, :"shipping"
        "yellow-500"
      when :shipped, :"shipped", :completed, :"completed"
        "green-500"
      else
        "gray-400"
      end
    end
  end
end
