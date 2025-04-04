require 'rails_helper'

RSpec.describe "Pledge Creation", type: :system do
  let(:creator) { create(:user, name: "Creator") }
  let(:backer) { create(:user, name: "Backer", email: "backer@example.com", password: "password") }
  let(:project) { create(:project, creator: creator, title: "Test Project", description: "A test project") }
  let!(:reward) { create(:reward, project: project, title: "Basic Reward", amount: 50, description: "Basic reward description") }
  let!(:premium_reward) { create(:reward, project: project, title: "Premium Reward", amount: 100, description: "Premium reward description") }

  before do
    # Log in as a backer
    visit login_path
    fill_in "Email", with: backer.email
    fill_in "Password", with: "password"
    click_button "Sign in"
  end

  scenario "Backer creates a pledge with a reward", js: true do
    visit project_path(project)
    click_link "Back this project"
    
    expect(page).to have_content("Back This Project")
    expect(page).to have_content(project.title)
    
    # Select a reward
    choose "pledge_reward_id_#{reward.id}"
    
    # Set pledge amount
    fill_in "Pledge Amount ($)", with: "60"
    
    # Submit the form
    click_button "Complete Pledge"
    
    # Check redirected to project page with success message
    expect(page).to have_content("Thank you for backing this project!")
    expect(page).to have_current_path(project_path(project))
    
    # Verify pledge was created in database
    expect(Pledge.last.reward).to eq(reward)
    expect(Pledge.last.amount).to eq(60)
  end

  scenario "Backer creates a pledge without a reward", js: true do
    visit new_pledge_path(project_id: project.id)
    
    # Choose "no reward"
    choose "pledge_reward_id_"
    
    # Set pledge amount
    fill_in "Pledge Amount ($)", with: "25"
    
    # Submit the form
    click_button "Complete Pledge"
    
    # Verify successful pledge
    expect(page).to have_content("Thank you for backing this project!")
    
    # Verify pledge was created in database with nil reward
    expect(Pledge.last.reward).to be_nil
    expect(Pledge.last.amount).to eq(25)
  end

  scenario "Backer cannot pledge below reward minimum", js: true do
    visit new_pledge_path(project_id: project.id)
    
    # Choose premium reward
    choose "pledge_reward_id_#{premium_reward.id}"
    
    # Set pledge amount below minimum
    fill_in "Pledge Amount ($)", with: "75"
    
    # Submit the form
    click_button "Complete Pledge"
    
    # Expect error - note that the actual error doesn't include the $ symbol
    expect(page).to have_content("Amount must be at least 100.0 to select this reward")
    expect(Pledge.where(amount: 75)).to be_empty
  end

  scenario "Starting with a pre-selected reward", js: true do
    visit new_pledge_path(project_id: project.id, reward_id: premium_reward.id)
    
    # Should see the reward pre-selected
    expect(page).to have_content("Selected Reward: Premium Reward")
    expect(page).to have_content("Minimum pledge: $100.00")
    
    # Amount should be pre-filled with the reward amount (note the decimal format)
    expect(find_field("Pledge Amount ($)").value).to eq("100.0")
    
    # Submit with a higher amount
    fill_in "Pledge Amount ($)", with: "150"
    click_button "Complete Pledge"
    
    # Verify successful pledge
    expect(page).to have_content("Thank you for backing this project!")
    expect(Pledge.last.reward).to eq(premium_reward)
    expect(Pledge.last.amount).to eq(150)
  end
end
