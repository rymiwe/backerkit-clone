class RewardItem < ApplicationRecord
  include Fulfillable
  
  belongs_to :reward
  has_many :wave_items, dependent: :destroy
  has_many :fulfillment_waves, through: :wave_items
  has_many :backer_item_fulfillments, dependent: :destroy
  
  validates :name, presence: true
  validates :quantity_per_reward, presence: true, numericality: { greater_than: 0 }
  validates :total_needed, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :produced_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :shipped_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :name, uniqueness: { scope: :reward_id, message: "must be unique within a reward" }
  validates_with ShippingCountValidator
  
  before_validation :calculate_total_needed, if: :needs_total_calculation?
  
  def production_percentage
    return 0 if total_needed.zero?
    [(produced_count.to_f / total_needed * 100).round, 100].min
  end
  
  def shipping_percentage
    return 0 if total_needed.zero?
    [(shipped_count.to_f / total_needed * 100).round, 100].min
  end
  
  # Added to support tests expecting needed_count method
  def needed_count
    total_needed
  end
  
  def status
    if produced_count >= total_needed && total_needed > 0
      "ready"
    elsif produced_count > 0
      "in_progress" 
    else
      "not_started"
    end
  end
  
  # New methods for tracking individual backer fulfillment
  def fulfilled_for_backer?(pledge)
    backer_item_fulfillments.where(pledge: pledge, shipped: true).exists?
  end
  
  def create_backer_fulfillments!
    reward.pledges.each do |pledge|
      # Only create if it doesn't already exist
      unless backer_item_fulfillments.exists?(pledge: pledge)
        backer_item_fulfillments.create!(pledge: pledge, shipped: false)
      end
    end
  end
  
  def fulfillment_rate
    total_backers = reward.pledges.count
    return 0 if total_backers.zero?
    
    fulfilled_backers = backer_item_fulfillments.where(shipped: true).count
    [(fulfilled_backers.to_f / total_backers * 100).round, 100].min
  end
  
  private
  
  def calculate_total_needed
    backer_count = reward.pledges.count
    self.total_needed = backer_count * quantity_per_reward
  end
  
  def needs_total_calculation?
    reward.present? && quantity_per_reward.present? && 
    (total_needed.nil? || total_needed.zero? || reward_id_changed? || quantity_per_reward_changed?)
  end
end
