class Reward < ApplicationRecord
  belongs_to :project
  has_many :pledges
  has_many :reward_items, dependent: :destroy
  
  validates :title, presence: true
  validates :description, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  
  # Fulfillment status constants
  STATUSES = {
    not_started: 'not_started',
    in_production: 'in_production',
    in_transit: 'in_transit',
    shipping_soon: 'shipping_soon',
    shipping: 'shipping',
    completed: 'completed'
  }
  
  validates :status, inclusion: { in: STATUSES.values }, allow_nil: true
  validates :fulfillment_progress, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validate :status_and_progress_consistency
  
  # Helper methods for status
  def status_name
    case status
    when STATUSES[:not_started] then "Not Started"
    when STATUSES[:in_production] then "In Production"
    when STATUSES[:in_transit] then "In Transit"
    when STATUSES[:shipping_soon] then "Shipping Soon"
    when STATUSES[:shipping] then "Shipping"
    when STATUSES[:completed] then "Completed"
    else "Unknown"
    end
  end
  
  def status_color
    case status
    when STATUSES[:not_started] then "gray"
    when STATUSES[:in_production] then "blue"
    when STATUSES[:in_transit] then "indigo"
    when STATUSES[:shipping_soon] then "purple"
    when STATUSES[:shipping] then "orange"
    when STATUSES[:completed] then "green"
    else "gray"
    end
  end
  
  def fulfillment_status_percentage
    fulfillment_progress || 0
  end
  
  def backers_count
    pledges.count
  end
  
  # New methods for item-level tracking
  def items_produced_percentage
    return 0 if reward_items.empty?
    
    total_needed = reward_items.sum(:total_needed)
    return 0 if total_needed == 0
    
    produced = reward_items.sum(:produced_count)
    [(produced.to_f / total_needed * 100).round, 100].min
  end
  
  def items_shipped_percentage
    return 0 if reward_items.empty?
    
    total_needed = reward_items.sum(:total_needed)
    return 0 if total_needed == 0
    
    shipped = reward_items.sum(:shipped_count)
    [(shipped.to_f / total_needed * 100).round, 100].min
  end
  
  def fulfillable_backer_count
    return 0 if reward_items.empty?
    
    # If all items are fully produced, all backers can be fulfilled
    if reward_items.all? { |item| item.produced_count >= item.total_needed && item.total_needed > 0 }
      return pledges.count
    end
    
    # Otherwise, find the most limiting item
    min_fulfillable = Float::INFINITY
    
    reward_items.each do |item|
      next if item.quantity_per_reward == 0
      
      backers_this_item = (item.produced_count / item.quantity_per_reward).to_i
      min_fulfillable = [min_fulfillable, backers_this_item].min
    end
    
    min_fulfillable == Float::INFINITY ? 0 : min_fulfillable
  end
  
  def has_items?
    reward_items.exists?
  end
  
  def production_bottleneck
    return nil if reward_items.empty?
    
    # Find the item with the lowest production percentage
    reward_items.min_by { |item| item.production_percentage }
  end
  
  private
  
  def status_and_progress_consistency
    return if status.nil? || fulfillment_progress.nil?
    
    if status == STATUSES[:not_started] && fulfillment_progress > 0
      errors.add(:fulfillment_progress, "must be 0 when status is 'Not Started'")
    elsif status == STATUSES[:completed] && fulfillment_progress < 100
      errors.add(:fulfillment_progress, "must be 100 when status is 'Completed'")
    elsif status == STATUSES[:in_production] && (fulfillment_progress < 1 || fulfillment_progress > 40)
      errors.add(:fulfillment_progress, "should be between 1-40% for 'In Production' status")
    elsif status == STATUSES[:in_transit] && (fulfillment_progress < 41 || fulfillment_progress > 70)
      errors.add(:fulfillment_progress, "should be between 41-70% for 'In Transit' status")
    elsif status == STATUSES[:shipping_soon] && (fulfillment_progress < 71 || fulfillment_progress > 85)
      errors.add(:fulfillment_progress, "should be between 71-85% for 'Shipping Soon' status")
    elsif status == STATUSES[:shipping] && (fulfillment_progress < 86 || fulfillment_progress > 99)
      errors.add(:fulfillment_progress, "should be between 86-99% for 'Shipping' status")
    end
  end
end
