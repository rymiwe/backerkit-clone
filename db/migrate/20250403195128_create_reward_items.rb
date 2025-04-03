class CreateRewardItems < ActiveRecord::Migration[7.1]
  def change
    create_table :reward_items do |t|
      t.string :name, null: false
      t.text :description
      t.integer :quantity_per_reward, null: false, default: 1
      t.integer :total_needed, null: false, default: 0
      t.integer :produced_count, null: false, default: 0
      t.integer :shipped_count, null: false, default: 0
      t.references :reward, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :reward_items, [:reward_id, :name], unique: true
  end
end
