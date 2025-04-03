class WaveItem < ApplicationRecord
  belongs_to :fulfillment_wave
  belongs_to :reward_item
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  
  # Ensure an item can only be included once in a wave
  validates :reward_item_id, uniqueness: { scope: :fulfillment_wave_id, 
                                         message: "is already included in this fulfillment wave" }
  
  def fulfilled_count
    reward_item.backer_item_fulfillments.fulfilled.count
  end
  
  def fulfillment_percentage
    return 0 if quantity.zero?
    [(fulfilled_count.to_f / quantity * 100).round, 100].min
  end
end
