class AddProductionPriorityToRewardItems < ActiveRecord::Migration[7.1]
  def change
    add_column :reward_items, :production_priority, :integer
  end
end
