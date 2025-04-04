require 'rails_helper'

RSpec.describe "Dashboard Tabs", type: :system do
  let!(:user) { create(:user, email: 'test@example.com', password: 'password') }
  let!(:project1) { create(:project, title: "Project One", creator: user) }
  let!(:project2) { create(:project, title: "Project Two") }
  
  before do
    # Create a pledge so the user has backed a project
    create(:pledge, backer: user, project: project2, amount: 50.00)
    
    # Log in
    visit login_path
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
  end

  it "maintains the selected tab when navigating away and back to dashboard" do
    # Visit dashboard initially
    visit dashboard_path
    
    # Verify we see backed projects tab content by default
    expect(page).to have_content("Projects I've Backed")
    expect(page).to have_selector("#backed", visible: true)  # Backed projects tab is visible
    expect(page).to have_selector("#created", visible: false) # Created projects tab is hidden
    
    # Verify content in the visible tab
    within("#backed") do
      expect(page).to have_content("Project Two")  # Backed project is visible
    end
    
    # Click on the "Projects I've Created" tab
    click_link "Projects I've Created"
    
    # Now check visibility of tabs has changed
    expect(page).to have_selector("#backed", visible: false)  # Backed projects tab is now hidden
    expect(page).to have_selector("#created", visible: true)  # Created projects tab is now visible
    
    # Verify content in the newly visible tab
    within("#created") do
      expect(page).to have_content("Project One")  # Created project is visible
    end
    
    # Navigate away to discover page (which is at projects_path, not root_path)
    click_link "Discover"
    expect(page).to have_current_path(projects_path)
    
    # Go back to dashboard
    click_link "Dashboard"
    
    # The "Projects I've Created" tab should still be active - this is what fails in current implementation
    expect(page).to have_selector("#backed", visible: false)  # Backed projects tab should be hidden
    expect(page).to have_selector("#created", visible: true)  # Created projects tab should be visible
    
    # Verify the right content is visible
    within("#created") do
      expect(page).to have_content("Project One")  # Created project should still be visible
    end
  end
end
