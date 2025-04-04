class AddTrackingInfoToBackerItemFulfillments < ActiveRecord::Migration[7.1]
  def change
    add_column :backer_item_fulfillments, :tracking_number, :string
    add_column :backer_item_fulfillments, :tracking_url, :string
    # Notes column already exists, so we don't need to add it again
  end
end
