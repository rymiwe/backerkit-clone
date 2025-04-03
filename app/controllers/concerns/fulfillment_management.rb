module FulfillmentManagement
  extend ActiveSupport::Concern
  
  included do
    before_action :set_project
    before_action :ensure_project_owner, if: :require_project_owner?
  end
  
  def process_rewards_fulfillment
    @rewards = @project.rewards.includes(:pledges)
    
    # Set default values for rewards without fulfillment data
    @rewards.each do |reward|
      reward.status ||= 'not_started'
      reward.fulfillment_progress ||= 0
    end
  end
  
  def handle_fulfillment_update(reward)
    if reward.update(fulfillment_params)
      respond_to do |format|
        format.html { 
          redirect_to success_redirect_path, 
          notice: 'Fulfillment status was successfully updated.' 
        }
        format.json { 
          render json: { 
            status: 'success', 
            message: 'Fulfillment status updated' 
          } 
        }
      end
    else
      respond_to do |format|
        format.html { 
          redirect_to success_redirect_path, 
          alert: 'Failed to update fulfillment status.' 
        }
        format.json { 
          render json: { 
            status: 'error', 
            message: 'Failed to update fulfillment status' 
          } 
        }
      end
    end
  end
  
  private
  
  def set_project
    @project = Project.find(params[:project_id])
  end
  
  def ensure_project_owner
    unless @project.creator == current_user
      flash[:alert] = "You don't have permission to manage this project"
      redirect_to project_path(@project)
    end
  end
  
  def require_project_owner?
    true
  end
  
  def fulfillment_params
    params.require(:reward).permit(:status, :fulfillment_progress, :estimated_shipping_date)
  end
  
  # Should be implemented by including controllers
  def success_redirect_path
    raise NotImplementedError, "Subclasses must define success_redirect_path"
  end
end
