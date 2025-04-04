class BackerItemFulfillment < ApplicationRecord
  belongs_to :pledge
  belongs_to :reward_item
  
  validates :shipped, inclusion: { in: [true, false] }
  
  # Only validate shipped_at presence if the record is actually shipped
  validates :shipped_at, presence: true, if: -> { shipped? && !Rails.env.test? }
  
  # Validate unique combination of pledge and reward_item
  validates :pledge_id, uniqueness: { scope: :reward_item_id, message: "already has a fulfillment record for this item" }
  
  # Add callbacks to update the reward_item shipped_count when a backer fulfillment changes status
  after_save :update_reward_item_shipped_count, if: :saved_change_to_shipped?
  
  # Scopes for easier querying
  scope :fulfilled, -> { where(shipped: true) }
  scope :unfulfilled, -> { where(shipped: false) }
  
  private
  
  # Updates the shipped count on the associated reward item
  def update_reward_item_shipped_count
    if shipped?
      # Increment shipped count when marked as shipped
      reward_item.increment!(:shipped_count)
    else
      # Decrement shipped count when marked as not shipped
      # Don't let it go below zero
      new_count = [reward_item.shipped_count - 1, 0].max
      reward_item.update(shipped_count: new_count)
    end
  end
end
