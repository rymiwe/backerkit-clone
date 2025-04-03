class Pledge < ApplicationRecord
  belongs_to :backer, class_name: 'User'
  belongs_to :project
  belongs_to :reward, optional: true
  has_many :backer_item_fulfillments, dependent: :destroy
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  
  # Ensure pledge amount meets minimum for the selected reward
  validate :pledge_meets_reward_minimum, if: -> { reward.present? }
  
  # Define fulfillment status values
  enum fulfillment_status: {
    not_started: 'not_started',
    partial: 'partial',
    complete: 'complete'
  }, _default: 'not_started'
  
  # Scopes for easier querying
  scope :unfulfilled, -> { where(fulfillment_status: :not_started) }
  scope :partially_fulfilled, -> { where(fulfillment_status: :partial) }
  scope :completely_fulfilled, -> { where(fulfillment_status: :complete) }
  
  def calculate_fulfillment_status
    return 'not_started' if reward.nil? || reward.reward_items.empty?
    
    total_items = reward.reward_items.sum(:quantity_per_reward)
    fulfilled_items = backer_item_fulfillments.joins(:reward_item).where(shipped: true).count
    
    if fulfilled_items == 0
      'not_started'
    elsif fulfilled_items < total_items
      'partial'
    else
      'complete'
    end
  end
  
  def update_fulfillment_status!
    new_status = calculate_fulfillment_status
    update(fulfillment_status: new_status) unless fulfillment_status == new_status
  end
  
  private
  
  def pledge_meets_reward_minimum
    if amount < reward.amount
      errors.add(:amount, "must be at least #{reward.amount} to select this reward")
    end
  end
end
