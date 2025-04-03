class BackerItemFulfillment < ApplicationRecord
  belongs_to :pledge
  belongs_to :reward_item
  
  validates :shipped, inclusion: { in: [true, false] }
  validates :shipped_at, presence: true, if: :shipped
  
  # Validate unique combination of pledge and reward_item
  validates :pledge_id, uniqueness: { scope: :reward_item_id, message: "already has a fulfillment record for this item" }
  
  # Scopes for easier querying
  scope :fulfilled, -> { where(shipped: true) }
  scope :unfulfilled, -> { where(shipped: false) }
end
