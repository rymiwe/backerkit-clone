# config/initializers/view_component.rb
Rails.application.config.view_component.render_monkey_patch_enabled = true

# Set up view component previews
Rails.application.config.view_component.preview_paths = [
  Rails.root.join("spec/components/previews")
]

# Set up lookbook (if it's available in the current environment)
if defined?(Lookbook)
  Rails.application.config.lookbook.project_name = "BackerKit Clone UI"
  Rails.application.config.lookbook.preview_paths = [
    Rails.root.join("spec/components/previews")
  ]
end
