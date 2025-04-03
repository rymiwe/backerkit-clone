class CreateFulfillmentWaves < ActiveRecord::Migration[7.1]
  def change
    create_table :fulfillment_waves do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name
      t.date :target_ship_date
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
