class ComponentLibraryController < ApplicationController
  def index
    # Sample data for demos
    @progress_values = [0, 25, 50, 75, 100]
    @statuses = [
      "not_started", 
      "in_progress", 
      "in_production",
      "in_transit",
      "shipping_soon",
      "awaiting_shipping", 
      "shipping", 
      "completed"
    ]
    
    # Dummy data for tables
    @sample_items = [
      {name: "Limited Edition Poster", quantity: 1, status: "completed", progress: 100},
      {name: "Collector's T-Shirt", quantity: 2, status: "in_production", progress: 45},
      {name: "Vinyl Record", quantity: 1, status: "not_started", progress: 0},
      {name: "Digital Download", quantity: 1, status: "shipping_soon", progress: 80}
    ]
  end
end
