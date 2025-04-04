require 'rails_helper'

RSpec.describe "Navigation", type: :system do
  let!(:user) { create(:user, email: 'test@example.com', password: 'password') }
  let!(:project1) { create(:project, title: "Project One", creator: user) }
  let!(:project2) { create(:project, title: "Project Two") }
  let!(:project3) { create(:project, title: "Project Three") }
  
  before do
    # Create a pledge so the user has backed a project
    create(:pledge, backer: user, project: project2, amount: 50.00)
  end

  describe "Navigation between Dashboard and Discover" do
    it "properly shows all projects when navigating from Dashboard to Discover" do
      # Log in
      visit login_path
      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "password"
      click_button "Sign in"
      
      # Verify we're logged in
      expect(page).to have_content("Logged in successfully")
      
      # First, visit the dashboard
      click_link "Dashboard"
      expect(page).to have_current_path(dashboard_path)
      expect(page).to have_content("My Dashboard")
      
      # The dashboard initially shows backed projects tab
      expect(page).to have_selector("#backed", visible: true)
      expect(page).to have_content("Project Two") # Backed project
      
      # Switch to created projects tab to see Project One
      click_link "Projects I've Created"
      
      # Now we should see Project One in the active tab
      expect(page).to have_selector("#created", visible: true)
      within("#created") do
        expect(page).to have_content("Project One") # Created project
      end
      
      # Now click the Discover link
      click_link "Discover"
      
      # Should redirect to the projects path
      expect(page).to have_current_path(projects_path)
      
      # The discover page should show ALL projects
      expect(page).to have_content("Project One")
      expect(page).to have_content("Project Two")
      expect(page).to have_content("Project Three")
      
      # Visit dashboard again - should remember we were on the Created tab
      click_link "Dashboard"
      expect(page).to have_current_path(dashboard_path)
      
      # The created projects tab should still be visible due to our tab persistence
      expect(page).to have_selector("#created", visible: true)
      within("#created") do
        expect(page).to have_content("Project One")
      end
      
      # Go back to Discover
      click_link "Discover"
      expect(page).to have_current_path(projects_path)
      
      # Still should show ALL projects
      expect(page).to have_content("Project One")
      expect(page).to have_content("Project Two")
      expect(page).to have_content("Project Three")
    end
  end
end
