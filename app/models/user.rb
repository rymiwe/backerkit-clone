class User < ApplicationRecord
  has_secure_password
  
  # Store roles as an array in the database
  serialize :roles, type: Array, coder: JSON
  
  # Add direct association with projects
  has_many :projects, foreign_key: 'creator_id'
  # Add associations for pledges and backed projects
  has_many :pledges, foreign_key: 'backer_id'
  has_many :backed_projects, through: :pledges, source: :project, class_name: 'Project'

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  
  def is_creator?
    has_role?('creator')
  end
  
  def is_backer?
    has_role?('backer')
  end
  
  def make_creator
    add_role('creator')
  end
  
  def make_backer
    add_role('backer')
  end
  
  def make_admin
    add_role('admin')
  end
  
  def has_role?(role)
    (roles || []).include?(role.to_s)
  end
  
  # Returns the total amount pledged across all projects
  def total_pledged
    pledges.sum(:amount)
  end
  
  # Returns the count of unique projects backed
  def backed_projects_count
    backed_projects.distinct.count
  end
  
  private
  
  def add_role(role)
    self.roles = (roles || []) << role.to_s unless has_role?(role)
  end
  
  def remove_role(role)
    self.roles = (roles || []) - [role.to_s]
  end
end
