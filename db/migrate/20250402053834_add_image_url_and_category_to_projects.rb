class AddImageUrlAndCategoryToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :image_url, :string
    add_column :projects, :category, :string
  end
end
