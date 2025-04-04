require 'rails_helper'

RSpec.describe Reward, type: :model do
  # Create a valid creator and project to use throughout the tests
  let(:creator) { User.create(name: "Creator", email: "creator@example.com", password: "password") }
  let(:project) { Project.create(title: "Test Project", description: "Test description", goal: 1000.0, creator: creator, status: 'active', end_date: 1.month.from_now) }
  
  describe "validations" do
    it "requires a title" do
      reward = Reward.new(description: "Test description", amount: 100.0, project: project)
      expect(reward.valid?).to be false
      expect(reward.errors[:title]).to include("can't be blank")
    end

    it "requires a description" do
      reward = Reward.new(title: "Test Reward", amount: 100.0, project: project)
      expect(reward.valid?).to be false
      expect(reward.errors[:description]).to include("can't be blank")
    end

    it "requires an amount" do
      reward = Reward.new(title: "Test Reward", description: "Test description", project: project)
      expect(reward.valid?).to be false
      expect(reward.errors[:amount]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "belongs to a project" do
      association = Reward.reflect_on_association(:project)
      expect(association.macro).to eq :belongs_to
    end

    it "has many pledges" do
      association = Reward.reflect_on_association(:pledges)
      expect(association.macro).to eq :has_many
    end
    
    it "has many reward_items" do
      association = Reward.reflect_on_association(:reward_items)
      expect(association).not_to be_nil
      expect(association.macro).to eq :has_many if association
    end
  end

  describe "fulfillment status" do
    it "has a status attribute for tracking fulfillment" do
      reward = Reward.create(title: "Test Reward", description: "Test description", amount: 100.0, project: project)
      expect(reward).to respond_to(:status)
      expect(reward.status).to eq('not_started') # Default value from schema
    end
    
    it "tracks fulfillment progress percentage" do
      reward = Reward.create(title: "Test Reward", description: "Test description", amount: 100.0, project: project)
      expect(reward).to respond_to(:fulfillment_progress)
    end
    
    it "tracks estimated delivery date" do
      reward = Reward.create(title: "Test Reward", description: "Test description", amount: 100.0, project: project)
      expect(reward).to respond_to(:estimated_delivery)
    end
  end

  describe "reward items management" do
    let(:reward) { Reward.create(title: "Test Reward", description: "Test description", amount: 100.0, project: project) }
    
    it "can manage reward items quantity" do
      # This is a placeholder that will need to be implemented based on your actual reward items implementation
      expect(reward).to be_valid
    end
    
    it "can calculate total backers" do
      backer1 = User.create(name: "Backer 1", email: "backer1@example.com", password: "password")
      backer2 = User.create(name: "Backer 2", email: "backer2@example.com", password: "password")
      
      Pledge.create(backer: backer1, project: project, reward: reward, amount: 100.0)
      Pledge.create(backer: backer2, project: project, reward: reward, amount: 100.0)
      
      expect(reward.pledges.count).to eq(2)
    end
  end
end
