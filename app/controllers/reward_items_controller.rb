class RewardItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reward
  before_action :set_reward_item, only: [:update, :destroy]
  before_action :authorize_creator!
  
  def create
    @reward_item = @reward.reward_items.build(reward_item_params)
    
    respond_to do |format|
      if @reward_item.save
        format.html { redirect_to project_fulfillment_dashboard_path(@reward.project), notice: "Item was successfully added." }
        format.json { render json: @reward_item, status: :created }
      else
        format.html { redirect_to project_fulfillment_dashboard_path(@reward.project), alert: @reward_item.errors.full_messages.join(", ") }
        format.json { render json: @reward_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @reward_item.update(reward_item_params)
        format.html { redirect_to project_fulfillment_dashboard_path(@reward.project), notice: "Item was successfully updated." }
        format.json { render json: @reward_item, status: :ok }
      else
        format.html { redirect_to project_fulfillment_dashboard_path(@reward.project), alert: @reward_item.errors.full_messages.join(", ") }
        format.json { render json: @reward_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @reward_item.destroy
    
    respond_to do |format|
      format.html { redirect_to project_fulfillment_dashboard_path(@reward.project), notice: "Item was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  
  def set_reward
    @reward = Reward.find(params[:reward_id])
  end
  
  def set_reward_item
    @reward_item = @reward.reward_items.find(params[:id])
  end
  
  def reward_item_params
    params.require(:reward_item).permit(:name, :description, :quantity_per_reward, :produced_count, :shipped_count)
  end
  
  def authorize_creator!
    unless current_user == @reward.project.creator
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to root_path
    end
  end
end
