class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @backed_projects = current_user.backed_projects.distinct.includes(:creator).order(created_at: :desc)
    @created_projects = current_user.projects.includes(:pledges).order(created_at: :desc)
    @recent_pledges = current_user.pledges.includes(:project, :reward).order(created_at: :desc).limit(5)
    
    # Statistics
    @total_pledged = current_user.total_pledged
    @backed_count = current_user.backed_projects_count
    @created_count = @created_projects.count
    
    # Project funding stats for created projects
    @total_funding_received = @created_projects.sum { |p| p.pledges.sum(:amount) }
    @avg_funding_percentage = @created_projects.any? ? (@created_projects.sum { |p| p.funded_percentage } / @created_projects.count.to_f).round : 0
  end
  
  def backed_projects
    @backed_projects = current_user.backed_projects.distinct.includes(:creator).order(created_at: :desc)
  end
  
  def created_projects
    @created_projects = current_user.projects.includes(:pledges).order(created_at: :desc)
  end
end
