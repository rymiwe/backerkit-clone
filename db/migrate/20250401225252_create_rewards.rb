class CreateRewards < ActiveRecord::Migration[7.1]
  def change
    create_table :rewards do |t|
      t.references :project, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.decimal :amount, precision: 10, scale: 2
      t.integer :quantity
      t.integer :claimed_count, default: 0

      t.timestamps
    end
  end
end
