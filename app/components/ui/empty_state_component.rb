module Ui
  # @abstract A component for displaying empty states consistently across the application
  #
  # @example Basic usage
  #   <%= render(Ui::EmptyStateComponent.new(
  #     title: "No projects yet",
  #     description: "Get started by creating your first project",
  #     action_text: "Create Project",
  #     action_path: new_project_path,
  #     icon: :folder
  #   )) %>
  class EmptyStateComponent < ViewComponent::Base
    attr_reader :title, :description, :action_text, :action_path, :icon
    
    # Available icon types
    ICONS = {
      folder: "M9 13h6m-3-3v6m5 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z",
      document: "M9 13h6m-3-3v6m-9 1V7a2 2 0 012-2h6l2 2h6a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2z",
      users: "M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z",
      box: "M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4",
      calendar: "M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z",
      search: "M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
    }
    
    # Initialize a new empty state component
    # @param title [String] The main heading for the empty state
    # @param description [String] Additional explanation text
    # @param action_text [String] Text for the action button (optional)
    # @param action_path [String] URL for the action button (optional)
    # @param icon [Symbol] Icon to display (:folder, :document, :users, :box, :calendar, :search)
    def initialize(title:, description:, action_text: nil, action_path: nil, icon: :document)
      @title = title
      @description = description
      @action_text = action_text
      @action_path = action_path
      @icon = ICONS[icon.to_sym] || ICONS[:document]
    end
  end
end
