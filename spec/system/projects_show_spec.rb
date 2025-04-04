require 'rails_helper'

RSpec.describe "Project show page", type: :system do
  let(:creator) { create(:user, name: "Creator", email: "creator@example.com", password: "password") }
  let(:backer) { create(:user, name: "Backer", email: "backer@example.com", password: "password") }
  let(:project) { create(:project, creator: creator, title: "Test Project", description: "A test project") }
  let!(:reward) { create(:reward, project: project, title: "Basic Reward", amount: 25.0) }
  
  before do
    visit project_path(project)
  end
  
  scenario "displays project title and description" do
    expect(page).to have_content(project.title)
    expect(page).to have_content(project.description)
  end
  
  scenario "displays rewards" do
    expect(page).to have_content(reward.title)
    expect(page).to have_content("$25.00 or more")
  end
  
  scenario "displays project status information" do
    expect(page).to have_content("days to go")
  end
  
  context "when logged in as the creator" do
    before do
      visit login_path
      fill_in "Email", with: creator.email
      fill_in "Password", with: "password"
      click_button "Sign in"
      visit project_path(project)
    end
    
    scenario "shows creator actions" do
      expect(page).to have_link("Dashboard")
      expect(page).to have_link("Fulfillment")
      expect(page).to have_link("Edit")
      expect(page).to have_button("Delete")
    end
  end
  
  context "when viewing related projects section" do
    let(:unique_category) { "Unique#{Time.now.to_i}" } # Create a unique category
    let!(:related_project) { create(:project, title: "Related Test Project", category: unique_category) }
    
    before do
      # Use a unique category to avoid conflicts with seed data
      project.update!(category: unique_category)
      
      # Force reload the page after setting up the related project
      visit project_path(project)
    end
    
    scenario "displays related projects in the same category" do
      # Check section header with category name
      expect(page).to have_content("More #{unique_category} Projects") 
      
      # Verify the related project appears somewhere on the page
      expect(page).to have_content("Related Test Project")
      
      # Take a screenshot if the test fails to help debug
      page.save_screenshot("tmp/related_projects_test.png") if ENV['CI']
    end
  end
  
  # This scenario would have caught our namespace conflict issue
  scenario "renders status badges correctly" do
    expect(page).to have_css(".rounded-full") # The status badge should be rendered
  end
end
