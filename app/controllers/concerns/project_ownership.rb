module ProjectOwnership
  extend ActiveSupport::Concern
  
  included do
    before_action :set_project, only: project_owner_actions_list
    before_action :ensure_project_owner, only: project_owner_actions_list
  end
  
  class_methods do
    def project_owner_actions(*actions)
      @owner_actions = actions if actions.any?
      @owner_actions ||= []
    end
    
    def project_owner_actions_list
      @owner_actions ||= []
    end
  end
  
  protected
  
  def set_project
    @project = Project.find(params[:project_id] || params[:id])
  end
  
  def ensure_project_owner
    unless @project.creator == current_user
      flash[:alert] = "You don't have permission to modify this project"
      redirect_to project_path(@project)
    end
  end
end
