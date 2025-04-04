class FulfillmentWave < ApplicationRecord
  include Fulfillable
  
  belongs_to :project
  has_many :wave_items, dependent: :destroy
  has_many :reward_items, through: :wave_items
  
  validates :name, presence: true
  validates :target_ship_date, presence: true
  validates :status, presence: true
  
  # FulfillmentWave specific statuses (augments the basic statuses from Fulfillable)
  enum status: {
    planned: 'planned',
    in_progress: 'in_progress',
    shipping: 'shipping',
    completed: 'completed'
  }
  
  # Scope for upcoming waves
  scope :upcoming, -> { where("target_ship_date > ?", Date.today) }
  scope :past_due, -> { where("target_ship_date < ? AND status != ?", Date.today, statuses[:completed]) }
  
  def progress_percentage
    return 0 if wave_items.empty?
    
    total_items = wave_items.sum(:quantity)
    fulfilled_items = wave_items.joins(reward_item: :backer_item_fulfillments)
                              .where(backer_item_fulfillments: { shipped: true })
                              .count
    
    [(fulfilled_items.to_f / total_items * 100).round, 100].min
  end
end
