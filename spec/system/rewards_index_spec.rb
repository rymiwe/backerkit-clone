require 'rails_helper'

RSpec.describe "Rewards index page", type: :system do
  let(:creator) { create(:user, name: "Creator", email: "creator@example.com", password: "password") }
  let(:backer) { create(:user, name: "Backer", email: "backer@example.com", password: "password") }
  let(:project) { create(:project, creator: creator, title: "Test Project", description: "A test project") }
  let!(:reward1) { create(:reward, project: project, title: "Basic Reward", amount: 25.0) }
  let!(:reward2) { create(:reward, project: project, title: "Premium Reward", amount: 100.0, description: "A premium reward with extra perks") }

  context "when visiting the rewards index page" do
    before do
      visit project_rewards_path(project)
    end

    scenario "displays rewards list" do
      expect(page).to have_content("Rewards")
      expect(page).to have_content("Basic Reward")
      expect(page).to have_content("Premium Reward")
      expect(page).to have_content("$25.0")
      expect(page).to have_content("$100.0")
      expect(page).to have_content("A premium reward with extra perks")
    end

    scenario "has a link back to the project" do
      expect(page).to have_link("← Back to Project")
    end
  end

  context "when logged in as the creator" do
    before do
      visit login_path
      fill_in "Email", with: creator.email
      fill_in "Password", with: "password"
      click_button "Sign in"
      visit project_rewards_path(project)
    end

    scenario "shows creator actions" do
      expect(page).to have_link("Add New Reward")
      expect(page).to have_link("Edit")
      expect(page).to have_button("Delete")
    end
  end

  context "when logged in as a non-creator" do
    before do
      visit login_path
      fill_in "Email", with: backer.email
      fill_in "Password", with: "password"
      click_button "Sign in"
      visit project_rewards_path(project)
    end

    scenario "does not show creator actions" do
      expect(page).not_to have_link("Add New Reward")
      expect(page).not_to have_link("Edit")
      expect(page).not_to have_button("Delete")
    end
  end

  context "when no rewards exist" do
    let(:empty_project) { create(:project, creator: creator, title: "Empty Project") }

    before do
      visit project_rewards_path(empty_project)
    end

    scenario "shows empty state message" do
      expect(page).to have_content("No rewards have been created for this project yet")
    end
  end
end
