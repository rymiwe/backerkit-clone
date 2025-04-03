class Backer < User
  # This is a convenience class that provides backer-specific methods
  # All users can be backers by default, so no need to add roles explicitly
  
  # Get all pledges made by this user
  has_many :pledges, foreign_key: 'backer_id'
  
  # Get all projects backed by this user
  has_many :backed_projects, through: :pledges, source: :project
  
  # Returns the total amount pledged across all projects
  def total_pledged
    pledges.sum(:amount)
  end
  
  # Returns the count of unique projects backed
  def backed_projects_count
    backed_projects.distinct.count
  end
  
  # Returns projects backed in a specific category
  def backed_projects_by_category(category)
    backed_projects.where(category: category)
  end
end
