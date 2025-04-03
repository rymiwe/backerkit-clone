class CreateCampaigns < ActiveRecord::Migration[7.1]
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text :description
      t.decimal :goal
      t.datetime :end_date
      t.references :creator, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
