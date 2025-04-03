class CreatePledges < ActiveRecord::Migration[7.1]
  def change
    create_table :pledges do |t|
      t.references :backer, null: false, foreign_key: { to_table: :users }
      t.references :project, null: false, foreign_key: true
      t.references :reward, null: true, foreign_key: true  # Some pledges might not have rewards
      t.decimal :amount, precision: 10, scale: 2
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end
