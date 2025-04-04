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
    
    def primary_color
      "#4f46e5" # Indigo-600
    end
    
    def background_color
      "#e5e7eb" # Gray-200
    end
    
    def styles
      <<~CSS
        .slider-container {
          position: relative;
          width: 100%;
        }
        
        .slider-container input[type="range"] {
          -webkit-appearance: none;
          appearance: none;
          width: 100%;
          height: 8px;
          border-radius: 5px;
          background: #{background_color};
          outline: none;
          position: relative;
          z-index: 1;
        }
        
        .slider-container input[type="range"]::-webkit-slider-thumb {
          -webkit-appearance: none;
          appearance: none;
          width: 20px;
          height: 20px;
          border-radius: 50%;
          background: #{primary_color};
          cursor: pointer;
          position: relative;
          z-index: 3;
        }
        
        .slider-container input[type="range"]::-moz-range-thumb {
          width: 20px;
          height: 20px;
          border-radius: 50%;
          background: #{primary_color};
          cursor: pointer;
          position: relative;
          z-index: 3;
          border: none;
        }
        
        .slider-container::before {
          content: "";
          position: absolute;
          height: 8px;
          background-color: #{primary_color};
          border-radius: 5px 0 0 5px;
          top: 50%;
          transform: translateY(-50%);
          left: 0;
          width: var(--fill-percentage, 0%);
          pointer-events: none;
          z-index: 2;
        }
      CSS
    end
  end
end
