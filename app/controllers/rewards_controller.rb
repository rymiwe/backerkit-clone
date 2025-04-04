class RewardsController < ApplicationController
  include FulfillmentManagement
  
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_reward, only: [:show, :edit, :update, :destroy, :update_fulfillment]
  before_action :ensure_project_owner, except: [:index, :show]
  before_action :ensure_fulfillment_access, only: [:fulfillment, :update_fulfillment]

  # GET /projects/:project_id/rewards
  def index
    @rewards = @project.rewards
  end

  # GET /projects/:project_id/rewards/:id
  def show
  end

  # GET /projects/:project_id/rewards/new
  def new
    @reward = @project.rewards.new
  end

  # GET /projects/:project_id/rewards/:id/edit
  def edit
  end

  # POST /projects/:project_id/rewards
  def create
    @reward = @project.rewards.new(reward_params)

    if @reward.save
      redirect_to project_path(@project), notice: 'Reward was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/:project_id/rewards/:id
  def update
    if @reward.update(reward_params)
      redirect_to project_rewards_path(@project), notice: 'Reward was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /projects/:project_id/rewards/:id
  def destroy
    if @reward.pledges.any?
      redirect_to project_path(@project), alert: 'Cannot delete reward with pledges.'
    else
      @reward.destroy
      redirect_to project_path(@project), notice: 'Reward was successfully removed.'
    end
  end

  def fulfillment
    process_rewards_fulfillment
  end

  def update_fulfillment
    handle_fulfillment_update(@reward)
  end

  private
    # Use callbacks to share common setup or constraints between actions
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_reward
      @reward = @project.rewards.find(params[:id])
    end

    def ensure_project_owner
      unless current_user == @project.creator
        redirect_to project_path(@project), alert: "You don't have permission to manage rewards for this project."
      end
    end
    
    def ensure_fulfillment_access
      unless @project.creator == current_user
        redirect_to project_path(@project), alert: "You don't have permission to manage fulfillment for this project"
      end
    end

    def require_project_owner?
      # Override from concern to allow some actions without owner check
      action_name != 'index' && action_name != 'show'
    end

    # Only allow a list of trusted parameters through
    def reward_params
      params.require(:reward).permit(:title, :description, :amount, :estimated_shipping_date, :status, :fulfillment_progress)
    end
    
    def success_redirect_path
      fulfillment_project_rewards_path(@project)
    end
end
