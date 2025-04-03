class CreateSurveys < ActiveRecord::Migration[7.1]
  def change
    create_table :surveys do |t|
      t.references :project, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :status, default: 'draft'
      t.datetime :sent_at
      t.datetime :due_date

      t.timestamps
    end
  end
end
