class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.decimal :goal, precision: 10, scale: 2
      t.datetime :end_date
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.string :status, default: 'draft'

      t.timestamps
    end
  end
end
