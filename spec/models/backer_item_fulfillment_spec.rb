require 'rails_helper'

RSpec.describe BackerItemFulfillment do
  describe "associations" do
    it { should belong_to(:pledge) }
    it { should belong_to(:reward_item) }
  end

  describe "validations" do
    it "validates uniqueness of reward_item within a pledge" do
      pledge = create(:pledge)
      reward_item = create(:reward_item)
      create(:backer_item_fulfillment, pledge: pledge, reward_item: reward_item)

      duplicate = build(:backer_item_fulfillment, pledge: pledge, reward_item: reward_item)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:pledge_id]).to include("already has a fulfillment record for this item")
    end
  end

  describe "callbacks" do
    let(:project) { create(:project) }
    let(:reward) { create(:reward, project: project) }
    let(:reward_item) { create(:reward_item, reward: reward, produced_count: 10, shipped_count: 0) }
    let(:pledge) { create(:pledge, project: project, reward: reward) }

    it "increments reward_item shipped count when marked as shipped" do
      # Create a fulfillment marked as not shipped
      fulfillment = create(:backer_item_fulfillment, pledge: pledge, reward_item: reward_item, shipped: false)

      # Verify initial shipped count
      expect(reward_item.shipped_count).to eq(0)

      # Update to shipped
      fulfillment.update(shipped: true, shipped_at: Time.current)
      reward_item.reload

      # Should increment shipped count
      expect(reward_item.shipped_count).to eq(1)
    end

    it "decrements reward_item shipped count when unmarked as shipped" do
      # Create a fulfillment marked as shipped
      fulfillment = create(:backer_item_fulfillment, pledge: pledge, reward_item: reward_item, shipped: true, shipped_at: Time.current)

      # Verify initial shipped count after creating shipped fulfillment
      reward_item.reload
      initial_shipped = reward_item.shipped_count
      expect(initial_shipped).to be > 0

      # Update to not shipped
      fulfillment.update(shipped: false)
      reward_item.reload

      # Should decrement shipped count
      expect(reward_item.shipped_count).to eq(initial_shipped - 1)
    end
  end

  describe "CRUD operations" do
    let(:project) { create(:project) }
    let(:reward) { create(:reward, project: project) }
    let(:reward_item) { create(:reward_item, reward: reward) }
    let(:pledge) { create(:pledge, project: project, reward: reward) }

    it "creates a valid backer item fulfillment" do
      fulfillment = build(:backer_item_fulfillment, pledge: pledge, reward_item: reward_item, shipped: false)
      expect(fulfillment.save).to be true
      expect(described_class.count).to eq(1)
    end

    it "reads backer item fulfillment attributes" do
      tracking_number = "TRACK123456"
      tracking_url = "https://example.com/tracking"
      notes = "Special handling instructions"

      fulfillment = create(:backer_item_fulfillment,
                           pledge: pledge,
                           reward_item: reward_item,
                           shipped: true,
                           tracking_number: tracking_number,
                           tracking_url: tracking_url,
                           shipped_at: Time.current,
                           notes: notes)

      found_fulfillment = described_class.find(fulfillment.id)
      expect(found_fulfillment.shipped).to be(true)
      expect(found_fulfillment.tracking_number).to eq(tracking_number)
      expect(found_fulfillment.tracking_url).to eq(tracking_url)
      expect(found_fulfillment.notes).to eq(notes)
    end

    it "updates a backer item fulfillment" do
      fulfillment = create(:backer_item_fulfillment,
                           pledge: pledge,
                           reward_item: reward_item,
                           shipped: false,
                           tracking_number: nil)

      new_tracking = "UPDATED456"
      expect(fulfillment.update(shipped: true, shipped_at: Time.current, tracking_number: new_tracking)).to be true
      fulfillment.reload

      expect(fulfillment.shipped).to be(true)
      expect(fulfillment.tracking_number).to eq(new_tracking)
    end

    it "deletes a backer item fulfillment" do
      fulfillment = create(:backer_item_fulfillment, pledge: pledge, reward_item: reward_item)

      expect { fulfillment.destroy }.to change(described_class, :count).by(-1)
    end
  end

  describe "bulk operations" do
    let(:project) { create(:project) }
    let(:reward) { create(:reward, project: project) }
    let(:reward_item) { create(:reward_item, reward: reward, produced_count: 20, shipped_count: 0) }

    before do
      # Create 5 pledges and corresponding fulfillments
      5.times do |i|
        # Create unique backers for each pledge
        backer = create(:user, name: "Backer #{i}", email: "backer#{i}@example.com")
        pledge = create(:pledge, project: project, reward: reward, backer: backer)
        create(:backer_item_fulfillment, pledge: pledge, reward_item: reward_item, shipped: false)
      end
    end

    it "supports bulk marking as shipped" do
      fulfillments = described_class.where(reward_item: reward_item)
      expect(fulfillments.count).to eq(5)

      # Mark all as shipped with shipped_at timestamp
      fulfillments.each do |f|
        f.update(shipped: true, shipped_at: Time.current)
      end

      # Check all are now shipped
      expect(described_class.where(reward_item: reward_item, shipped: true).count).to eq(5)
      
      # Check reward_item shipped count increased
      reward_item.reload
      expect(reward_item.shipped_count).to eq(5)
    end
  end
end
