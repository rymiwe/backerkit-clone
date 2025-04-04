require 'rails_helper'

RSpec.describe RewardItem do
  describe "associations" do
    it { is_expected.to belong_to(:reward) }
    it { is_expected.to have_many(:wave_items).dependent(:destroy) }
    it { is_expected.to have_many(:fulfillment_waves).through(:wave_items) }
    it { is_expected.to have_many(:backer_item_fulfillments).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:quantity_per_reward) }
    it { is_expected.to validate_numericality_of(:quantity_per_reward).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:total_needed) }
    it { is_expected.to validate_numericality_of(:total_needed).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:produced_count) }
    it { is_expected.to validate_numericality_of(:produced_count).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:shipped_count) }
    it { is_expected.to validate_numericality_of(:shipped_count).is_greater_than_or_equal_to(0) }

    describe "custom validations" do
      let(:reward) { create(:reward) }

      it "validates that shipped count cannot exceed produced count" do
        item = build(:reward_item, reward: reward, produced_count: 5, shipped_count: 10)
        expect(item).not_to be_valid
        expect(item.errors[:shipped_count]).to include(/cannot exceed/)
      end

      it "validates uniqueness of name within a reward" do
        create(:reward_item, reward: reward, name: "Test Item")
        duplicate = build(:reward_item, reward: reward, name: "Test Item")
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:name]).to include(/must be unique within a reward/)
      end
    end
  end

  describe "callbacks" do
    let(:reward) { create(:reward) }
    let(:backer) { create(:user) }

    before do
      # Create two pledges for the reward
      create(:pledge, reward: reward, backer: backer)
      create(:pledge, reward: reward, backer: create(:user))
    end

    it "calculates total_needed based on pledges and quantity_per_reward" do
      item = create(:reward_item, reward: reward, quantity_per_reward: 2, total_needed: nil)
      expect(item.total_needed).to eq(4) # 2 pledges * 2 quantity_per_reward
    end

    it "doesn't recalculate total_needed if already set" do
      item = create(:reward_item, reward: reward, quantity_per_reward: 2, total_needed: 10)
      expect(item.total_needed).to eq(10) # Should keep the specified value
    end
  end

  describe "instance methods" do
    let(:item) { create(:reward_item, :half_produced) }

    it "calculates production percentage" do
      expect(item.production_percentage).to eq(50) # 10/20 * 100
    end

    it "calculates shipping percentage" do
      item = create(:reward_item, :half_shipped)
      expect(item.shipping_percentage).to eq(50) # 10/20 * 100
    end

    it "calculates needed_count" do
      expect(item.total_needed).to eq(20)
    end

    it "determines status based on production and shipping progress" do
      # Test various status states
      not_started = create(:reward_item, :not_started)
      expect(not_started.status).to eq("not_started")

      in_progress = create(:reward_item, :in_progress)
      expect(in_progress.status).to eq("in_progress")

      ready = create(:reward_item, :ready)
      expect(ready.status).to eq("ready")
    end
  end

  describe "CRUD operations" do
    let(:reward) { create(:reward) }

    it "creates a valid reward item" do
      item = build(:reward_item, reward: reward, name: "New Item", quantity_per_reward: 1)
      expect(item.save).to be true
      expect(described_class.count).to eq(1)
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
      item = create(:reward_item, reward: reward, name: "Original Name")

      expect(item.update(name: "Updated Name", production_priority: 5)).to be true
      item.reload

      expect(item.name).to eq("Updated Name")
      expect(item.production_priority).to eq(5)
    end

    it "deletes a reward item" do
      item = create(:reward_item, reward: reward)

      expect { item.destroy }.to change(described_class, :count).by(-1)
    end
  end
end
