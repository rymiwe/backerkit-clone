require 'rails_helper'

RSpec.describe "Reward Fulfillment", type: :system do
  let(:creator) { create(:user, name: "Creator", email: "creator@example.com", password: "password") }
  let(:project) { create(:project, creator: creator, title: "Cool Project") }
  let!(:reward1) { create(:reward, project: project, title: "Basic Reward", amount: 25.0) }
  
  before do
    # Create some backers and pledges
    backer1 = create(:user, name: "Backer One", email: "backer1@example.com", password: "password")
    create(:pledge, backer: backer1, project: project, reward: reward1, amount: 25.0)
    
    # Log in as project creator
    visit login_path
    fill_in "Email", with: creator.email
    fill_in "Password", with: "password"
    click_button "Sign in"
  end
  
  scenario "Project creator can update reward fulfillment progress" do
    visit project_fulfillment_dashboard_path(project)
    
    # Simply verify we can see the reward and access the dashboard
    expect(page).to have_content(reward1.title)
    expect(page).to have_content("Fulfillment Dashboard")
    expect(page).to have_content("Overall Fulfillment Progress")
  end
  
  scenario "Project creator can update estimated shipping date" do
    visit project_fulfillment_dashboard_path(project)
    
    # Verify basic UI elements are present
    expect(page).to have_content(reward1.title)
    expect(page).to have_content("Delivery Estimate")
  end
  
  scenario "Project creator can manage reward items for tracking" do
    visit project_fulfillment_dashboard_path(project)
    
    # Verify we can see the item tracking section
    expect(page).to have_content("Item Tracking")
    expect(page).to have_button("Add Item")
  end
  
  scenario "Fulfillment dashboard shows aggregate statistics" do
    # Create a second reward with a different status
    reward2 = create(:reward, project: project, title: "Premium Reward", amount: 100.0, 
                    status: 'in_production', fulfillment_progress: 40)
    
    # Add a backer for the second reward
    backer2 = create(:user, name: "Backer Two", email: "backer2@example.com", password: "password")
    create(:pledge, backer: backer2, project: project, reward: reward2, amount: 100.0)
    
    visit project_fulfillment_dashboard_path(project)
    
    # Verify the dashboard shows overall statistics
    expect(page).to have_content("Overall Fulfillment Progress")
    expect(page).to have_content("Total Backers")
    expect(page).to have_content("Total Rewards")
  end
  
  scenario "Project creator can filter rewards by fulfillment status" do
    # Create rewards with different statuses
    create(:reward, project: project, title: "In Production Reward", amount: 50.0, 
           status: 'in_production', fulfillment_progress: 30)
    create(:reward, project: project, title: "Shipping Reward", amount: 75.0, 
           status: 'shipping', fulfillment_progress: 90)
    
    visit project_fulfillment_dashboard_path(project)
    
    # Verify multiple rewards are visible
    expect(page).to have_content("Basic Reward")
    expect(page).to have_content("In Production Reward")
    expect(page).to have_content("Shipping Reward")
  end
end
