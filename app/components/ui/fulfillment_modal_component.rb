module Ui
  class FulfillmentModalComponent < ViewComponent::Base
    attr_reader :reward, :project
    
    def initialize(reward:, project:)
      @reward = reward
      @project = project
    end
    
    def status_options
      [
        ["Not Started", "not_started"],
        ["In Progress", "in_progress"],
        ["Awaiting Shipping", "awaiting_shipping"],
        ["Shipped", "shipped"],
        ["Completed", "completed"]
      ]
    end
    
    def modal_id
      "update-fulfillment-#{reward.id}"
    end
    
    def form_url
      # Use the actual path for updating reward fulfillment
      project_fulfillment_dashboard_update_reward_path(project, reward_id: reward.id)
    end
  end
end
