require 'rails_helper'

RSpec.describe RewardItem do
  describe "associations" do
    it { should belong_to(:reward) }
    it { should have_many(:wave_items).dependent(:destroy) }
    it { should have_many(:fulfillment_waves).through(:wave_items) }
    it { should have_many(:backer_item_fulfillments).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:quantity_per_reward) }
    it { should validate_numericality_of(:quantity_per_reward).is_greater_than(0) }
    it { should validate_presence_of(:shipped_count) }
    it { should validate_numericality_of(:shipped_count).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:produced_count) }
    it { should validate_numericality_of(:produced_count).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:total_needed) }
    it { should validate_numericality_of(:total_needed).is_greater_than_or_equal_to(0) }

    describe "custom validations" do
      let(:reward) { create(:reward) }
      
      it "validates uniqueness of name within a reward" do
        create(:reward_item, reward: reward, name: "Unique Item")
        duplicate = build(:reward_item, reward: reward, name: "Unique Item")
        
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:name]).to include("must be unique within this reward")
      end
      
      it "validates that shipped count cannot exceed produced count" do
        item = build(:reward_item, reward: reward, produced_count: 10, shipped_count: 15)
        
        expect(item).not_to be_valid
        expect(item.errors[:shipped_count]).to include("cannot exceed produced count")
      end
    end
  end
  
  describe "callbacks" do
    let(:reward) { create(:reward) }
    let(:user) { create(:user) }
    let(:pledge) { create(:pledge, reward: reward, backer: user) }
    
    it "calculates total_needed based on pledges and quantity_per_reward" do
      # Create the reward_item after the pledge so callbacks recalculate total_needed
      item = build(:reward_item, reward: reward, quantity_per_reward: 2, total_needed: 0)
      expect { item.save }.to change { item.total_needed }.from(0).to(2)
    end
    
    it "doesn't recalculate total_needed if already set" do
      item = build(:reward_item, reward: reward, quantity_per_reward: 2, total_needed: 10)
      expect { item.save }.not_to change { item.total_needed }
    end
  end
  
  describe "instance methods" do
    let(:reward) { create(:reward) }
    let(:item) { create(:reward_item, 
                         reward: reward, 
                         produced_count: 20, 
                         shipped_count: 10,
                         total_needed: 30) }
    
    it "calculates production percentage" do
      expect(item.production_percentage).to eq(67) # 20/30 ≈ 67%
    end
    
    it "calculates shipping percentage" do
      expect(item.shipping_percentage).to eq(50) # 10/20 = 50%
    end
    
    it "calculates needed_count" do
      expect(item.needed_count).to eq(30) # Same as total_needed
    end
    
    it "determines status based on production and shipping progress" do
      # Default case: partially produced, partially shipped
      expect(item.status).to eq("in_progress")
      
      # Not started: produced_count = 0
      not_started = create(:reward_item, reward: reward, produced_count: 0, total_needed: 10)
      expect(not_started.status).to eq("not_started")
      
      # Ready: produced_count = total_needed but not fully shipped
      ready = create(:reward_item, reward: reward, produced_count: 10, shipped_count: 5, total_needed: 10)
      expect(ready.status).to eq("ready")
    end
  end
  
  describe "CRUD operations" do
    let(:reward) { create(:reward) }
    
    it "creates a valid reward item" do
      initial_count = RewardItem.count
      item = build(:reward_item, reward: reward, name: "New Item", quantity_per_reward: 1)
      expect(item.save).to be true
      expect(RewardItem.count).to eq(initial_count + 1)
    end
    
    it "reads reward item attributes" do
      item = create(:reward_item, reward: reward, name: "Test Item", quantity_per_reward: 2,
                                 produced_count: 10, shipped_count: 5, production_priority: 3)
      
      found_item = described_class.find(item.id)
      expect(found_item.name).to eq("Test Item")
      expect(found_item.quantity_per_reward).to eq(2)
      expect(found_item.production_priority).to eq(3)
      expect(found_item.produced_count).to eq(10)
      expect(found_item.shipped_count).to eq(5)
    end
    
    it "updates a reward item" do
      item = create(:reward_item, reward: reward, name: "Original Name", produced_count: 0)
      
      expect(item.update(name: "Updated Name", produced_count: 5)).to be true
      item.reload
      
      expect(item.name).to eq("Updated Name")
      expect(item.produced_count).to eq(5)
    end
    
    it "deletes a reward item" do
      item = create(:reward_item, reward: reward)
      item_id = item.id
      
      expect { item.destroy }.to change(described_class, :count).by(-1)
      expect { described_class.find(item_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
