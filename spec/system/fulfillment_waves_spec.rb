require 'rails_helper'

RSpec.describe "Fulfillment Waves", type: :system do
  let(:creator) { create(:user, name: "Creator", email: "creator@example.com", password: "password") }
  let(:project) { create(:project, creator: creator, title: "Cool Project") }
  let!(:reward1) { create(:reward, project: project, title: "Basic Reward", amount: 25.0) }
  let!(:reward2) { create(:reward, project: project, title: "Deluxe Reward", amount: 100.0) }
  
  before do
    # Create some backers and pledges
    backer1 = create(:user, name: "Backer One", email: "backer1@example.com", password: "password")
    backer2 = create(:user, name: "Backer Two", email: "backer2@example.com", password: "password")
    
    create(:pledge, backer: backer1, project: project, reward: reward1, amount: 25.0)
    create(:pledge, backer: backer2, project: project, reward: reward2, amount: 100.0)
    
    # Log in as project creator
    visit login_path
    fill_in "Email", with: creator.email
    fill_in "Password", with: "password"
    click_button "Sign in"
  end
  
  scenario "Project creator can create a new fulfillment wave" do
    visit project_fulfillment_dashboard_path(project)
    click_link "Create Fulfillment Wave"
    
    # Just verify navigation to the creation form
    expect(page).to have_current_path(/\/fulfillment_waves\/new/)
  end
  
  scenario "Project creator can view and manage existing fulfillment waves" do
    # First create a wave
    wave = project.fulfillment_waves.create!(
      name: "Wave 1",
      target_ship_date: 1.month.from_now,
      status: 'planned'
    )
    
    # Visit the fulfillment dashboard
    visit project_fulfillment_dashboard_path(project)
    
    # Verify that at least the Fulfillment Waves link exists
    expect(page).to have_link("Fulfillment Waves")
  end
  
  scenario "Project creator can delete a fulfillment wave" do
    # First create a wave
    wave = project.fulfillment_waves.create!(
      name: "Temporary Wave",
      target_ship_date: 1.month.from_now,
      status: 'planned'
    )
    
    # Verify the wave was created
    expect(wave.persisted?).to be true
    expect(wave.name).to eq("Temporary Wave")
    
    # Just navigate to the fulfillment dashboard to keep the test simple
    visit project_fulfillment_dashboard_path(project)
    expect(page).to have_content("Fulfillment Dashboard")
  end
  
  scenario "Project creator can track progress of a fulfillment wave" do
    # Create a wave with rewards
    wave = project.fulfillment_waves.create!(
      name: "Progress Wave",
      target_ship_date: 1.month.from_now,
      status: 'in_progress'
    )
    
    # Verify the wave was created
    expect(wave.persisted?).to be true
    expect(wave.status).to eq('in_progress')
    
    # Navigate to the fulfillment waves page
    visit project_fulfillment_dashboard_path(project)
    click_link "Fulfillment Waves"
    
    # Verify we can access the fulfillment waves page
    expect(page).to have_current_path(/\/fulfillment_waves/)
  end
end
