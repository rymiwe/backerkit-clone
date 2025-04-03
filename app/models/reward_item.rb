class RewardItem < ApplicationRecord
  belongs_to :reward
  
  validates :name, presence: true
  validates :quantity_per_reward, presence: true, numericality: { greater_than: 0 }
  validates :total_needed, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :produced_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :shipped_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :name, uniqueness: { scope: :reward_id, message: "must be unique within a reward" }
  validate :shipped_cannot_exceed_produced
  
  before_validation :calculate_total_needed, if: :needs_total_calculation?
  
  def production_percentage
    return 0 if total_needed.zero?
    [(produced_count.to_f / total_needed * 100).round, 100].min
  end
  
  def shipping_percentage
    return 0 if total_needed.zero?
    [(shipped_count.to_f / total_needed * 100).round, 100].min
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
  
  def status_badge_class
    case status
    when "ready"
      "bg-green-100 text-green-800"
    when "in_progress"
      "bg-yellow-100 text-yellow-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end
  
  def status_name
    case status
    when "ready" then "Ready"
    when "in_progress" then "In Progress"
    else "Not Started"
    end
  end
  
  private
  
  def shipped_cannot_exceed_produced
    if shipped_count && produced_count && shipped_count > produced_count
      errors.add(:shipped_count, "cannot exceed the number of produced items")
    end
  end
  
  def calculate_total_needed
    backer_count = reward.pledges.count
    self.total_needed = backer_count * quantity_per_reward
  end
  
  def needs_total_calculation?
    reward.present? && quantity_per_reward.present? && 
    (total_needed.nil? || total_needed.zero? || reward_id_changed? || quantity_per_reward_changed?)
  end
end
