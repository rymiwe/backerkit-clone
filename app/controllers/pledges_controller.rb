class PledgesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:new, :create]
  before_action :set_reward, only: [:new, :create], if: -> { params[:reward_id].present? }
  
  # GET /projects/:project_id/pledges/new
  def new
    @pledge = build_pledge
    @pledge.amount = @reward&.amount || 1
  end
  
  # POST /projects/:project_id/pledges
  def create
    # Clean up the params to handle "no reward" case properly
    clean_reward_params
    
    @pledge = build_pledge(pledge_params)
    
    if @pledge.save
      redirect_to project_path(@project), notice: 'Thank you for backing this project!'
    else
      render :new
    end
  end
  
  # GET /pledges
  def index
    @pledges = current_user.pledges.includes(:project, :reward).order(created_at: :desc)
  end
  
  private
  
  def set_project
    @project = Project.find(params[:project_id])
  end
  
  def set_reward
    @reward = @project.rewards.find(params[:reward_id])
  end
  
  def pledge_params
    params.require(:pledge).permit(:amount, :reward_id)
  end
  
  # Handle case where reward_id is submitted as empty string or "0"
  def clean_reward_params
    if params[:pledge] && (params[:pledge][:reward_id].blank? || params[:pledge][:reward_id] == "0")
      params[:pledge][:reward_id] = nil
    end
  end
  
  def build_pledge(attributes = {})
    pledge = Pledge.new(attributes)
    pledge.backer = current_user
    pledge.project = @project
    pledge.reward ||= @reward if @reward
    pledge
  end
end
