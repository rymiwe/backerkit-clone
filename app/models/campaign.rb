class Project < ApplicationRecord
  belongs_to :creator
  has_many :rewards
  has_many :pledges
  has_many :backers, through: :pledges
  has_many :surveys
  
  validates :title, presence: true
  validates :goal, presence: true, numericality: { greater_than: 0 }
  validates :end_date, presence: true
  validates :status, presence: true
  
  enum status: {
    draft: 'draft',
    live: 'live',
    successful: 'successful',
    failed: 'failed'
  }
  
  def funded_percentage
    total_pledged = pledges.sum(:amount)
    (total_pledged / goal * 100).round(2)
  end
  
  def successful?
    funded_percentage >= 100
  end
end
