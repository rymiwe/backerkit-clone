module Ui
  class ProgressSliderComponent < ViewComponent::Base
    attr_reader :reward, :project
    
    def initialize(reward:, project:)
      @reward = reward
      @project = project
    end
    
    def current_value
      reward.fulfillment_progress || 0
    end
    
    def status_color
      case reward.status
      when "not_started" then "gray"
      when "in_progress" then "blue"
      when "awaiting_shipping" then "yellow"
      when "shipped", "completed" then "green"
      else "gray"
      end
    end
    
    def form_url
      "/projects/#{project.id}/fulfillment_dashboard/update_reward"
    end
  end
end
