# frozen_string_literal: true

# Form object to handle the complex process of creating or updating a fulfillment wave
# This encapsulates form handling and validation in a single place, separating it from models and controllers
class FulfillmentWaveForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  
  # Define attributes with types
  attribute :name, :string
  attribute :description, :string
  attribute :project_id, :integer
  attribute :target_ship_date, :date
  attribute :status, :string
  attribute :item_ids, default: []
  attribute :quantity_map, default: {}
  
  # Validations
  validates :name, :project_id, :target_ship_date, :status, presence: true
  validates :target_ship_date, future_date: true, if: -> { target_ship_date.present? }
  validates :item_ids, presence: { message: "At least one item must be selected" }
  validate :valid_quantities
  
  # Constructor that can initialize from a FulfillmentWave model
  def initialize(attributes = {})
    if attributes.is_a?(FulfillmentWave)
      wave = attributes
      super(
        name: wave.name,
        description: wave.description,
        project_id: wave.project_id,
        target_ship_date: wave.target_ship_date,
        status: wave.status,
        item_ids: wave.wave_items.map { |wi| wi.reward_item_id.to_s },
        quantity_map: wave.wave_items.each_with_object({}) { |wi, map| map[wi.reward_item_id.to_s] = wi.quantity.to_s }
      )
      @wave = wave
    else
      super(attributes)
      @wave = nil
    end
  end
  
  # Save the form data to the database
  def save
    return false unless valid?
    
    ActiveRecord::Base.transaction do
      persist!
      true
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end
  
  # Access the saved wave
  def wave
    @wave
  end
  
  private
  
  # Validate that all quantities are positive numbers
  def valid_quantities
    item_ids.each do |item_id|
      quantity = quantity_map[item_id.to_s].to_i
      
      if quantity <= 0
        errors.add(:quantity_map, "Quantity for item ##{item_id} must be greater than zero")
      end
      
      # Check if the quantity exceeds available items
      item = RewardItem.find_by(id: item_id)
      if item && quantity > (item.needed_count - item.shipped_count)
        errors.add(:quantity_map, "Quantity for #{item.name} exceeds available items")
      end
    end
  end
  
  # Persist the form data to the database
  def persist!
    if @wave
      update_existing_wave
    else
      create_new_wave
    end
    
    @wave
  end
  
  # Create a new fulfillment wave
  def create_new_wave
    @wave = FulfillmentWave.create!(
      name: name,
      description: description,
      project_id: project_id,
      target_ship_date: target_ship_date,
      status: status
    )
    
    # Create wave items for the selected reward items
    item_ids.each do |item_id|
      quantity = quantity_map[item_id.to_s].to_i
      @wave.wave_items.create!(
        reward_item_id: item_id,
        quantity: quantity
      )
    end
  end
  
  # Update an existing fulfillment wave
  def update_existing_wave
    @wave.update!(
      name: name,
      description: description,
      target_ship_date: target_ship_date,
      status: status
    )
    
    # Handle wave items updates
    existing_item_ids = @wave.wave_items.pluck(:reward_item_id).map(&:to_s)
    
    # Remove items that are no longer selected
    items_to_remove = existing_item_ids - item_ids
    @wave.wave_items.where(reward_item_id: items_to_remove).destroy_all
    
    # Update or create wave items
    item_ids.each do |item_id|
      quantity = quantity_map[item_id.to_s].to_i
      wave_item = @wave.wave_items.find_or_initialize_by(reward_item_id: item_id)
      wave_item.update!(quantity: quantity)
    end
  end
end
