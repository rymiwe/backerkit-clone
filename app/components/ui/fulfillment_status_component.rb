module Ui
  class FulfillmentStatusComponent < ViewComponent::Base
    attr_reader :status, :progress
    
    def initialize(status:, progress: nil)
      @status = status.to_s
      @progress = progress
    end
    
    def status_badge_class
      case status.to_sym
      when :not_started
        "bg-gray-100 text-gray-800"
      when :in_production
        "bg-blue-100 text-blue-800"
      when :in_transit
        "bg-indigo-100 text-indigo-800"
      when :shipping_soon
        "bg-purple-100 text-purple-800"
      when :shipping
        "bg-orange-100 text-orange-800"
      when :completed
        "bg-green-100 text-green-800"
      else
        "bg-gray-100 text-gray-800"
      end
    end
    
    def status_name
      case status
      when "not_started" then "Not Started"
      when "in_production" then "In Production"
      when "in_transit" then "In Transit"
      when "shipping_soon" then "Shipping Soon"
      when "shipping" then "Shipping"
      when "completed" then "Completed"
      else status.humanize
      end
    end
    
    def progress_percentage
      return 0 if progress.nil?
      [[progress.to_i, 0].max, 100].min
    end
    
    def progress_color
      case status
      when "not_started" then "gray"
      when "in_production" then "blue"
      when "in_transit" then "indigo"
      when "shipping_soon" then "purple"
      when "shipping" then "orange"
      when "completed" then "green"
      else "gray"
      end
    end
  end
end
