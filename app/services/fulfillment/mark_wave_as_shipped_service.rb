module Fulfillment
  # Service object to handle the complex process of marking a fulfillment wave as shipped
  # This encapsulates the business logic in one place, making it more maintainable and testable
  class MarkWaveAsShippedService
    def initialize(wave, user)
      @wave = wave
      @user = user
      @project = wave.project
      @reward_items = wave.reward_items
    end

    def call
      return false unless valid?

      ActiveRecord::Base.transaction do
        update_wave_status
        update_item_shipping_counts
        create_shipping_records
        notify_backers if should_notify_backers?
        true
      end
    rescue StandardError => e
      Rails.logger.error("Error shipping wave: #{e.message}")
      false
    end

    private

    attr_reader :wave, :user, :project, :reward_items

    def valid?
      user == project.creator || user.admin?
    end

    def update_wave_status
      # Only update if not already in a shipping or completed state
      return if %w[shipping completed].include?(wave.status)

      wave.update!(status: 'shipping')
    end

    def update_item_shipping_counts
      reward_items.each do |item|
        # Only update shipping count if it's less than produced count
        quantity = [wave.wave_items.find_by(reward_item: item)&.quantity || 0,
                    item.produced_count - item.shipped_count].min

        next if quantity <= 0

        # Update the shipped count, ensuring it doesn't exceed the produced count
        new_shipped_count = [item.shipped_count + quantity, item.produced_count].min
        item.update!(shipped_count: new_shipped_count)
      end
    end

    def create_shipping_records
      # Find all related pledges for the wave items and create/update tracking records
      wave.wave_items.each do |wave_item|
        item = wave_item.reward_item
        reward = item.reward
        reward.pledges.each do |pledge|
          # Find or initialize the backer fulfillment record
          fulfillment = BackerItemFulfillment.find_or_initialize_by(
            pledge: pledge,
            reward_item: item
          )

          # Mark as shipped if it wasn't already
          fulfillment.update!(shipped: true) unless fulfillment.shipped?
        end
      end
    end

    def notify_backers
      # Placeholder for a future notification system
      # Could send emails to backers or create in-app notifications
      # This would likely call another service object
    end

    def should_notify_backers?
      # For now, always return false as notifications aren't implemented
      # In a real app, this could depend on user preferences or other factors
      false
    end
  end
end
