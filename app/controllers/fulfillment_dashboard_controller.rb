class FulfillmentDashboardController < ApplicationController
  include ProjectOwnership
  include FulfillmentManagement
  
  before_action :authenticate_user!
  before_action :set_reward, only: [:update_reward]
  before_action :set_reward_item, only: [:update_item_counts]
  
  # Define which actions require project ownership
  project_owner_actions :show, :update_reward, :update_item_counts
  
  def show
    process_rewards_fulfillment
  end
  
  def update_reward
    handle_fulfillment_update(@reward)
  end
  
  def update_item_counts
    if @reward_item.update(reward_item_params)
      flash[:notice] = "Item counts updated successfully."
    else
      flash[:alert] = @reward_item.errors.full_messages.join(", ")
    end
    
    redirect_to success_redirect_path
  end
  
  private
  
  def set_reward
    @reward = @project.rewards.find(params[:reward_id])
  end
  
  def set_reward_item
    @reward = @project.rewards.find(params[:reward_id])
    @reward_item = @reward.reward_items.find(params[:item_id])
  end
  
  def reward_item_params
    params.require(:reward_item).permit(:produced_count, :shipped_count)
  end
  
  def success_redirect_path
    project_fulfillment_dashboard_path(@project)
  end
end
