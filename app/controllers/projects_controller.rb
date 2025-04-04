class ProjectsController < ApplicationController
  include ProjectOwnership
  
  before_action :require_login, except: [:index, :show]
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:index]
  
  # Define which actions require project ownership
  project_owner_actions :edit, :update, :destroy

  def index
    @projects = Project.all
    
    # Filter by category if provided
    if params[:category].present?
      @projects = @projects.where(category: params[:category])
      @current_category = params[:category]
    end
  end

  def show
    # Find related projects in the same category, excluding the current project
    if @project.category.present?
      @related_projects = Project.where(category: @project.category)
                                 .where.not(id: @project.id)
                                 .limit(3)
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully deleted.'
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :goal, :end_date, :image_url, :category)
  end
  
  def set_categories
    @categories = Project.distinct.pluck(:category).compact.sort
  end
end
