class AddEstimatedDeliveryToRewards < ActiveRecord::Migration[7.1]
  def change
    add_column :rewards, :estimated_delivery, :date
  end
end
