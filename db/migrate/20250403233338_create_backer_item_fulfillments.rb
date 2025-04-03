class CreateBackerItemFulfillments < ActiveRecord::Migration[7.1]
  def change
    create_table :backer_item_fulfillments do |t|
      t.references :pledge, null: false, foreign_key: true
      t.references :reward_item, null: false, foreign_key: true
      t.boolean :shipped
      t.datetime :shipped_at
      t.text :notes

      t.timestamps
    end
  end
end
