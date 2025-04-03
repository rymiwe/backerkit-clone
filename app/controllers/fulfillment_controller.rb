class FulfillmentController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :ensure_project_owner

  def index
    @rewards = @project.rewards.includes(:pledges)
    
    # Set default values for rewards without fulfillment data
    @rewards.each do |reward|
      reward.status ||= 'not_started'
      reward.fulfillment_progress ||= 0
    end
  end

  def update_reward
    @reward = @project.rewards.find(params[:reward_id])
    
    if @reward.update(fulfillment_params)
      respond_to do |format|
        format.html { redirect_to project_fulfillment_path(@project), notice: 'Fulfillment status was successfully updated.' }
        format.json { render json: { status: 'success', message: 'Fulfillment status updated' } }
      end
    else
      respond_to do |format|
        format.html { redirect_to project_fulfillment_path(@project), alert: 'Failed to update fulfillment status.' }
        format.json { render json: { status: 'error', message: 'Failed to update fulfillment status' } }
      end
    end
  end

  private
    def set_project
      @project = Project.find(params[:project_id])
    end

    def ensure_project_owner
      unless @project.creator == current_user
        flash[:alert] = "You don't have permission to manage fulfillment for this project"
        redirect_to project_path(@project)
      end
    end

    def fulfillment_params
      params.require(:reward).permit(:status, :fulfillment_progress, :estimated_shipping_date)
    end
end
