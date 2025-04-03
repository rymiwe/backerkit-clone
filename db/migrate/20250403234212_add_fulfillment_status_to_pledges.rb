class AddFulfillmentStatusToPledges < ActiveRecord::Migration[7.1]
  def change
    add_column :pledges, :fulfillment_status, :string, default: 'not_started', null: false
  end
end
