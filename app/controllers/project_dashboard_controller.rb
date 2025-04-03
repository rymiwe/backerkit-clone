class ProjectDashboardController < ApplicationController
  include ProjectOwnership
  
  before_action :authenticate_user!
  
  # Define which actions require project ownership
  project_owner_actions :show, :backers, :rewards
  
  def show
    @backers = @project.pledges.includes(:backer).order(created_at: :desc)
    @rewards = @project.rewards.order(amount: :asc)
    @total_raised = @project.pledges.sum(:amount)
    @backer_count = @project.pledges.select(:backer_id).distinct.count
    @funding_percentage = @project.funded_percentage
  end
  
  def backers
    @backers = @project.pledges.includes(:backer, :reward).order(created_at: :desc)
  end
  
  def rewards
    @rewards = @project.rewards.order(amount: :asc)
  end
end
