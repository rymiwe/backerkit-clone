module RewardItem
  class StatusBadgeComponent < ViewComponent::Base
    attr_reader :status
    
    def initialize(status:)
      @status = status
    end
    
    def badge_class
      case status
      when "ready"
        "bg-green-100 text-green-800"
      when "in_progress"
        "bg-yellow-100 text-yellow-800"
      else
        "bg-gray-100 text-gray-800"
      end
    end
    
    def status_name
      case status
      when "ready" then "Ready"
      when "in_progress" then "In Progress"
      else "Not Started"
      end
    end
  end
end
