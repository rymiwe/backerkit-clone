class FixUrbanPerspectivesImage < ActiveRecord::Migration[7.1]
  def up
    project = Project.find_by(title: "Urban Perspectives - Street Art Photography Book")
    if project
      project.update_column(:image_url, "https://images.unsplash.com/photo-1481487196290-c152efe083f5?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80")
    end
  end

  def down
    project = Project.find_by(title: "Urban Perspectives - Street Art Photography Book")
    if project
      project.update_column(:image_url, "https://images.unsplash.com/photo-1561059488-916d69792237?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80")
    end
  end
end
