module Ui
  class StatusBadgeComponent < ViewComponent::Base
    attr_reader :status, :text
    
    def initialize(status:, text: nil)
      @status = status.to_s.gsub('_', '-')
      @text = text || status.to_s.titleize
    end
    
    def badge_class
      "status-badge status-badge-#{status}"
    end
  end
end
