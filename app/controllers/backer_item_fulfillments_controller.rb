class BackerItemFulfillmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :authorize_creator!
  before_action :set_pledge, only: [:update_for_backer]
  
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
    @reward_item = RewardItem.find(params[:reward_item_id])
    @reward = @reward_item.reward
    
    if @reward.project_id != @project.id
      redirect_to project_fulfillment_dashboard_path(@project), alert: "Item does not belong to this project"
      return
    end
    
    if params[:backer_ids].present?
      pledges = Pledge.where(id: params[:backer_ids])
      shipped = ActiveModel::Type::Boolean.new.cast(params[:shipped])
      
      ActiveRecord::Base.transaction do
        pledges.each do |pledge|
          fulfillment = BackerItemFulfillment.find_or_initialize_by(
            pledge: pledge,
            reward_item: @reward_item
          )
          
          # Only update if there's a change in shipped status
          if fulfillment.shipped != shipped
            fulfillment.shipped = shipped
            fulfillment.shipped_at = shipped ? Time.current : nil
            fulfillment.save!
            
            # Update pledge fulfillment status
            pledge.update_fulfillment_status!
          end
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
  
  def authorize_creator!
    unless current_user.id == @project.creator_id
      redirect_to root_path, alert: "You are not authorized to manage fulfillment for this project."
    end
  end
end
