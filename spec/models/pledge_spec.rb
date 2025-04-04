require 'rails_helper'

RSpec.describe Pledge, type: :model do
  # Create shared test objects
  let(:creator) { User.create(name: "Creator", email: "creator@example.com", password: "password") }
  let(:backer) { User.create(name: "Backer", email: "backer@example.com", password: "password") }
  let(:project) { Project.create(title: "Test Project", description: "Test description", goal: 1000.0, creator: creator, status: 'active', end_date: 1.month.from_now) }
  let(:reward) { Reward.create(title: "Test Reward", description: "Test description", amount: 100.0, project: project) }
  
  describe "validations" do
    it "requires an amount" do
      pledge = Pledge.new
      expect(pledge.valid?).to be false
      expect(pledge.errors[:amount]).to include("can't be blank")
    end

    it "requires a positive amount" do
      pledge = Pledge.new(amount: -10)
      expect(pledge.valid?).to be false
      expect(pledge.errors[:amount]).to include("must be greater than 0")
    end
  end

  describe "associations" do
    it "belongs to a backer (User)" do
      association = Pledge.reflect_on_association(:backer)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:class_name]).to eq 'User'
    end

    it "belongs to a project" do
      association = Pledge.reflect_on_association(:project)
      expect(association.macro).to eq :belongs_to
    end

    it "belongs to a reward (optional)" do
      association = Pledge.reflect_on_association(:reward)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to be true
    end
    
    it "has many backer_item_fulfillments" do
      association = Pledge.reflect_on_association(:backer_item_fulfillments)
      expect(association.macro).to eq :has_many
    end
  end

  describe "pledge creation" do
    it "can be created with a reward" do
      pledge = Pledge.create(backer: backer, project: project, reward: reward, amount: 100.0)
      expect(pledge.persisted?).to be true
      expect(pledge.reward).to eq(reward)
    end

    it "can be created without a reward" do
      pledge = Pledge.create(backer: backer, project: project, amount: 50.0)
      expect(pledge.persisted?).to be true
      expect(pledge.reward).to be_nil
    end
  end
  
  describe "fulfillment status" do
    let(:pledge) { Pledge.create(backer: backer, project: project, reward: reward, amount: 100.0) }
    
    it "defaults to 'not_started'" do
      expect(pledge.fulfillment_status).to eq("not_started")
    end
    
    it "has scopes for filtering by status" do
      expect(Pledge.unfulfilled).to include(pledge)
      
      # Test the other scopes are defined
      expect(Pledge).to respond_to(:partially_fulfilled)
      expect(Pledge).to respond_to(:completely_fulfilled)
    end
  end
end
