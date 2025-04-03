class AddFulfillmentStatusToRewards < ActiveRecord::Migration[7.1]
  def change
    add_column :rewards, :status, :string, default: 'not_started'
    add_column :rewards, :fulfillment_progress, :integer, default: 0
    add_column :rewards, :estimated_shipping_date, :date
  end
end
