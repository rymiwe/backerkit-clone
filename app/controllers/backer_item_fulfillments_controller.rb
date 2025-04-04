class BackerItemFulfillmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_pledge, except: [:bulk_update, :generate_for_reward]
  before_action :set_fulfillment, only: [:update, :destroy]
  before_action :authorize_creator_or_backer!
  
  # Standard RESTful actions to match tests
  def index
    @fulfillments = @pledge.backer_item_fulfillments.includes(:reward_item)
  end
  
  def create
    @fulfillment = @pledge.backer_item_fulfillments.new(fulfillment_params)
    
    if @fulfillment.save
      redirect_to project_pledge_path(@project, @pledge), notice: "Fulfillment record created successfully"
    else
      redirect_to project_pledge_path(@project, @pledge), alert: "Failed to create fulfillment record"
    end
  end
  
  def update
    if @fulfillment.update(fulfillment_params)
      redirect_to project_pledge_path(@project, @pledge), notice: "Fulfillment status updated successfully"
    else
      redirect_to project_pledge_path(@project, @pledge), alert: "Failed to update fulfillment status"
    end
  end
  
  def destroy
    if @fulfillment.shipped?
      redirect_to project_pledge_path(@project, @pledge), alert: "Cannot delete shipped fulfillment records"
    else
      @fulfillment.destroy
      redirect_to project_pledge_path(@project, @pledge), notice: "Fulfillment record deleted successfully"
    end
  end
  
  # Update all items for a specific pledge (backer)
  def update_for_backer
    if params[:item_statuses].present?
      ActiveRecord::Base.transaction do
        params[:item_statuses].each do |item_id, shipped|
          shipped_bool = ActiveModel::Type::Boolean.new.cast(shipped)
          reward_item = RewardItem.find(item_id)
          
          fulfillment = BackerItemFulfillment.find_or_initialize_by(
            pledge: @pledge,
            reward_item: reward_item
          )
          
          # Only update if there's a change in shipped status
          if fulfillment.shipped != shipped_bool
            fulfillment.shipped = shipped_bool
            fulfillment.shipped_at = shipped_bool ? Time.current : nil
            fulfillment.save!
            
            # Update pledge fulfillment status
            @pledge.update_fulfillment_status!
          end
        end
      end
      
      redirect_to project_pledge_path(@project, @pledge), notice: "Fulfillment status updated successfully"
    else
      redirect_to project_pledge_path(@project, @pledge), alert: "No items were updated"
    end
  end
  
  # Bulk update for a specific item across multiple backers
  def bulk_update
    @reward_item = RewardItem.find(params[:reward_item_id]) if params[:reward_item_id].present?
    
    if params[:fulfillment_ids].present?
      fulfillments = BackerItemFulfillment.where(id: params[:fulfillment_ids])
      shipped = ActiveModel::Type::Boolean.new.cast(params[:shipped])
      
      BackerItemFulfillment.transaction do
        fulfillments.each do |fulfillment|
          fulfillment.update!(shipped: shipped, shipped_at: shipped ? Time.current : nil)
          fulfillment.pledge.update_fulfillment_status! if fulfillment.pledge.respond_to?(:update_fulfillment_status!)
        end
      end
      
      redirect_to project_fulfillment_dashboard_path(@project), notice: "Fulfillment status updated for all selected backers"
    else
      redirect_to project_fulfillment_dashboard_path(@project), alert: "No backers were selected"
    end
  end
  
  # Generate fulfillment records for all backers of a reward
  def generate_for_reward
    @reward = @project.rewards.find(params[:reward_id])
    
    # Find all items for this reward
    reward_items = @reward.reward_items
    
    # For each item, create fulfillment records for all backers
    reward_items.each(&:create_backer_fulfillments!)
    
    redirect_to project_fulfillment_dashboard_path(@project), 
                notice: "Fulfillment tracking has been initialized for all backers of this reward"
  end
  
  private
  
  def set_project
    @project = Project.find(params[:project_id])
  end
  
  def set_pledge
    @pledge = @project.pledges.find(params[:pledge_id])
  end
  
  def set_fulfillment
    @fulfillment = @pledge.backer_item_fulfillments.find(params[:id])
  end
  
  def authorize_creator_or_backer!
    # Allow project creator full access
    return true if current_user.id == @project.creator_id
    
    # Allow backers to view their own pledges, but not update
    if @pledge && current_user.id == @pledge.backer_id
      # Only allow GET requests for non-creators
      unless request.get?
        redirect_to root_path, alert: "You are not authorized to modify fulfillment records."
        return false
      end
      return true
    end
    
    # Not authorized
    redirect_to root_path, alert: "You are not authorized to access this resource."
    false
  end
  
  def fulfillment_params
    params.require(:backer_item_fulfillment).permit(:reward_item_id, :shipped)
  end
end
