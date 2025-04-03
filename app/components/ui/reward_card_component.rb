module Ui
  class RewardCardComponent < ViewComponent::Base
    attr_reader :reward, :show_actions
    
    def initialize(reward:, show_actions: true)
      @reward = reward
      @show_actions = show_actions
    end
    
    def backer_count
      reward.pledges.count
    end
    
    def backer_text
      backer_count == 1 ? "1 backer" : "#{backer_count} backers"
    end
    
    def status
      reward.status || "not_started"
    end
    
    def progress
      reward.fulfillment_progress || 0
    end
    
    def estimated_delivery
      return "Not specified" unless reward.estimated_delivery
      reward.estimated_delivery.strftime("%B %Y")
    end
    
    def estimated_shipping
      return "Not specified" unless reward.estimated_shipping_date
      reward.estimated_shipping_date.strftime("%B %d, %Y")
    end
    
    def can_update?
      show_actions
    end
  end
end
