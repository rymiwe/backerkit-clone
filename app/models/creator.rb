class Creator < User
  # This is a convenience class that provides creator-specific methods
  # All users can be creators by default, so no need to add roles explicitly
  
  # Get all projects created by this user
  has_many :projects, foreign_key: 'creator_id'
  
  # Returns the total number of projects created
  def total_projects_count
    projects.count
  end
  
  # Returns the total funding amount across all projects
  def total_funding
    projects.joins(:pledges).sum('pledges.amount')
  end
  
  # Returns all projects in a specific category
  def projects_by_category(category)
    projects.where(category: category)
  end
  
  # Returns projects with funding percentage above a threshold
  def successful_projects(threshold = 100)
    projects.select { |project| project.funded_percentage >= threshold }
  end
end
