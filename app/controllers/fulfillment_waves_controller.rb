class FulfillmentWavesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :authorize_creator!
  before_action :set_fulfillment_wave, only: [:show, :edit, :update, :destroy]
  
  def index
    @fulfillment_waves = @project.fulfillment_waves.order(target_ship_date: :asc)
  end
  
  def show
    @wave_items = @fulfillment_wave.wave_items.includes(:reward_item)
  end
  
  def new
    @fulfillment_wave = @project.fulfillment_waves.build
    @available_items = available_reward_items
  end
  
  def create
    @fulfillment_wave = @project.fulfillment_waves.build(fulfillment_wave_params)
    
    if @fulfillment_wave.save
      handle_wave_items
      redirect_to project_fulfillment_waves_path(@project), notice: "Fulfillment wave was successfully created."
    else
      @available_items = available_reward_items
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @available_items = available_reward_items
    @selected_items = @fulfillment_wave.wave_items.map { |wi| [wi.reward_item_id, wi.quantity] }.to_h
  end
  
  def update
    if @fulfillment_wave.update(fulfillment_wave_params)
      @fulfillment_wave.wave_items.destroy_all # Remove existing items
      handle_wave_items
      redirect_to project_fulfillment_waves_path(@project), notice: "Fulfillment wave was successfully updated."
    else
      @available_items = available_reward_items
      @selected_items = params[:wave_items]&.to_unsafe_h || {}
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @fulfillment_wave.destroy
    redirect_to project_fulfillment_waves_path(@project), notice: "Fulfillment wave was successfully deleted."
  end
  
  private
  
  def set_project
    @project = Project.find(params[:project_id])
  end
  
  def set_fulfillment_wave
    @fulfillment_wave = @project.fulfillment_waves.find(params[:id])
  end
  
  def authorize_creator!
    unless current_user.id == @project.creator_id
      redirect_to root_path, alert: "You are not authorized to manage fulfillment for this project."
    end
  end
  
  def fulfillment_wave_params
    params.require(:fulfillment_wave).permit(:name, :target_ship_date, :description, :status)
  end
  
  def available_reward_items
    # Get all reward items across all rewards for the project
    RewardItem.joins(reward: :project).where(rewards: { project_id: @project.id })
  end
  
  def handle_wave_items
    return unless params[:wave_items].present?
    
    params[:wave_items].each do |item_id, quantity|
      next if quantity.to_i <= 0
      
      @fulfillment_wave.wave_items.create(
        reward_item_id: item_id,
        quantity: quantity.to_i
      )
    end
  end
end
