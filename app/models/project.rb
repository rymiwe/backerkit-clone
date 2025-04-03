class Project < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :rewards, dependent: :destroy
  has_many :pledges, dependent: :destroy
  
  validates :title, presence: true
  validates :description, presence: true
  validates :goal, presence: true, numericality: { greater_than: 0 }
  validates :end_date, presence: true
  
  def funded_percentage
    total_pledged = pledges.sum(:amount)
    goal.zero? ? 0 : (total_pledged / goal.to_f * 100).round
  end
  
  def total_backers
    pledges.select(:backer_id).distinct.count
  end
  
  def days_remaining
    return 0 if end_date.nil? || end_date.to_date < Date.today
    (end_date.to_date - Date.today).to_i
  end
end
