# frozen_string_literal: true

# Concern for models that participate in the fulfillment process
# This allows sharing common fulfillment-related functionality across different models
module Fulfillable
  extend ActiveSupport::Concern
  
  included do
    # Common scopes for fulfillment tracking
    scope :fulfilled, -> { where(fulfillment_progress: 100) }
    scope :in_progress, -> { where('fulfillment_progress > ? AND fulfillment_progress < ?', 0, 100) }
    scope :not_started, -> { where(fulfillment_progress: 0) }
    
    # Don't add status enum here since models like FulfillmentWave already have it
    # Different models might use different status values
  end
  
  # Common methods for fulfillment tracking
  
  def fulfilled?
    return false unless respond_to?(:fulfillment_progress)
    fulfillment_progress == 100
  end
  
  def mark_as_fulfilled!
    return false unless respond_to?(:fulfillment_progress) && respond_to?(:status)
    
    update!(
      fulfillment_progress: 100,
      status: 'completed'
    )
  end
  
  def status_color
    return 'gray' unless respond_to?(:status)
    
    case status
    when 'completed'
      'green'
    when 'shipping'
      'yellow'
    when 'in_production'
      'blue'
    else
      'gray'
    end
  end
  
  # Calculate which stage a fulfillable item is in based on its progress
  def calculate_status
    return 'not_started' unless respond_to?(:fulfillment_progress)
    
    if fulfillment_progress == 0
      'not_started'
    elsif fulfillment_progress == 100
      'completed'
    elsif fulfillment_progress > 50
      'shipping'
    else
      'in_production'
    end
  end
  
  # Update status based on current fulfillment progress
  def update_status_from_progress!
    return false unless respond_to?(:fulfillment_progress) && respond_to?(:status)
    
    update_column(:status, calculate_status)
  end
end
