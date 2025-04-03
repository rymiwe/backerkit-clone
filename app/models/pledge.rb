class Pledge < ApplicationRecord
  belongs_to :backer, class_name: 'User'
  belongs_to :project
  belongs_to :reward, optional: true
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  
  # Ensure pledge amount meets minimum for the selected reward
  validate :pledge_meets_reward_minimum, if: -> { reward.present? }
  
  private
  
  def pledge_meets_reward_minimum
    if amount < reward.amount
      errors.add(:amount, "must be at least #{reward.amount} to select this reward")
    end
  end
end
