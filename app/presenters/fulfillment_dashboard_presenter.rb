# frozen_string_literal: true

# Presenter for the fulfillment dashboard
# This encapsulates view-specific data manipulation and calculations
class FulfillmentDashboardPresenter
  attr_reader :project
  
  def initialize(project)
    @project = project
  end
  
  # Calculate the overall project fulfillment progress
  def overall_progress
    return 0 if total_items.zero?
    
    total_progress = reward_items.sum do |item|
      item.needed_count * (item.shipped_count.to_f / [item.needed_count, 1].max)
    end
    
    [(total_progress / total_items * 100).round, 100].min
  end
  
  # Group waves by their status for display in the dashboard
  def waves_by_status
    {
      completed: completed_waves,
      shipping: shipping_waves,
      in_progress: in_progress_waves,
      planned: planned_waves
    }
  end
  
  # Calculate statistics for the dashboard summary
  def statistics
    {
      total_items_needed: total_items,
      total_items_produced: reward_items.sum(:produced_count),
      total_items_shipped: reward_items.sum(:shipped_count),
      total_waves: project.fulfillment_waves.count,
      completed_waves: completed_waves.count,
      in_progress_waves: in_progress_waves.count + shipping_waves.count,
      planned_waves: planned_waves.count
    }
  end
  
  # Items that need to be included in a fulfillment wave
  def unassigned_items
    reward_items.select do |item|
      item.needed_count > wave_items.where(reward_item: item).sum(:quantity)
    end
  end
  
  # Get items sorted by production priority (high to low)
  def prioritized_items
    reward_items.order(production_priority: :desc)
  end
  
  # Get waves that are behind schedule
  def waves_behind_schedule
    project.fulfillment_waves
           .where('target_ship_date < ? AND status != ?', Date.current, 'completed')
           .order(target_ship_date: :asc)
  end
  
  # Get the next upcoming wave with the closest target date
  def next_shipping_wave
    project.fulfillment_waves
           .where('target_ship_date >= ?', Date.current)
           .order(target_ship_date: :asc)
           .first
  end
  
  # Calculate days remaining until the next shipping wave
  def days_until_next_shipping
    return nil unless next_shipping_wave
    
    (next_shipping_wave.target_ship_date - Date.current).to_i
  end
  
  # Format URLs for the dashboard
  def urls
    {
      new_wave_path: Rails.application.routes.url_helpers.new_project_fulfillment_wave_path(project),
      waves_index_path: Rails.application.routes.url_helpers.project_fulfillment_waves_path(project),
      project_path: Rails.application.routes.url_helpers.project_path(project)
    }
  end
  
  private
  
  def reward_items
    @reward_items ||= project.rewards.flat_map(&:reward_items)
  end
  
  def total_items
    @total_items ||= reward_items.sum(:needed_count)
  end
  
  def wave_items
    @wave_items ||= WaveItem.joins(:fulfillment_wave)
                           .where(fulfillment_waves: { project_id: project.id })
  end
  
  def completed_waves
    @completed_waves ||= waves_query.call(status: 'completed')
  end
  
  def shipping_waves
    @shipping_waves ||= waves_query.call(status: 'shipping')
  end
  
  def in_progress_waves
    @in_progress_waves ||= waves_query.call(status: 'in_progress')
  end
  
  def planned_waves
    @planned_waves ||= waves_query.call(status: 'planned')
  end
  
  def waves_query
    @waves_query ||= FulfillmentWaves::ByStatusQuery.new(project.fulfillment_waves)
  end
end
