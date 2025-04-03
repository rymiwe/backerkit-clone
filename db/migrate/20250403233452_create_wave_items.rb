class CreateWaveItems < ActiveRecord::Migration[7.1]
  def change
    create_table :wave_items do |t|
      t.references :fulfillment_wave, null: false, foreign_key: true
      t.references :reward_item, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
