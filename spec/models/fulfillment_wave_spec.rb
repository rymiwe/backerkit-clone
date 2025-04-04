require 'rails_helper'

RSpec.describe FulfillmentWave do
  describe "associations" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_many(:wave_items).dependent(:destroy) }
    it { is_expected.to have_many(:reward_items).through(:wave_items) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:target_ship_date) }
    it { is_expected.to validate_presence_of(:status) }

    it "defines status enum values" do
      expect(described_class.statuses.keys).to include(
        "planned", "in_progress", "shipping", "completed"
      )
    end
  end

  describe "scopes" do
    let(:project) { create(:project) }
    let!(:past_due_wave) do
      create(:fulfillment_wave, project: project, target_ship_date: Date.yesterday, status: 'in_progress')
    end
    let!(:upcoming_wave) do
      create(:fulfillment_wave, project: project, target_ship_date: Date.tomorrow, status: 'planned')
    end
    let!(:completed_wave) do
      create(:fulfillment_wave, project: project, target_ship_date: Date.yesterday, status: 'completed')
    end

    it "finds upcoming waves" do
      expect(described_class.upcoming).to include(upcoming_wave)
      expect(described_class.upcoming).not_to include(past_due_wave, completed_wave)
    end

    it "finds past due waves" do
      expect(described_class.past_due).to include(past_due_wave)
      expect(described_class.past_due).not_to include(upcoming_wave, completed_wave)
    end
  end

  describe "instance methods" do
    let(:project) { create(:project) }
    let(:reward) { create(:reward, project: project) }
    let(:reward_item) { create(:reward_item, reward: reward) }
    let(:backer) { create(:user) }
    let(:wave) { create(:fulfillment_wave, project: project) }

    before do
      # Create pledges and fulfillments for proper progress calculation
      pledge = create(:pledge, reward: reward, backer: backer, project: project)
      create(:wave_item, fulfillment_wave: wave, reward_item: reward_item, quantity: 10)

      # Create 5 shipping fulfillments to get 50% shipped
      5.times do
        create(:backer_item_fulfillment, reward_item: reward_item, pledge: pledge, shipped: true)
      end
    end

    it "calculates progress percentage" do
      expect(wave.progress_percentage).to be_between(45, 55).inclusive
    end

    it "returns 0% progress when there are no wave items" do
      empty_wave = create(:fulfillment_wave, project: project)
      expect(empty_wave.progress_percentage).to eq(0)
    end

    it "caps progress at 100%" do
      # Create more shipping fulfillments than needed
      pledge = create(:pledge, reward: reward, backer: create(:user), project: project)
      15.times do
        create(:backer_item_fulfillment, reward_item: reward_item, pledge: pledge, shipped: true)
      end

      expect(wave.progress_percentage).to eq(100)
    end
  end

  describe "CRUD operations" do
    let(:project) { create(:project) }

    it "creates a valid fulfillment wave" do
      wave = build(:fulfillment_wave,
                   project: project,
                   name: "New Wave",
                   target_ship_date: Time.zone.today + 30.days,
                   status: 'planned')
      expect(wave.save).to be true
      expect(described_class.count).to eq(1)
    end

    it "reads fulfillment wave attributes" do
      wave = create(:fulfillment_wave,
                    project: project,
                    name: "Test Wave",
                    description: "Wave description",
                    target_ship_date: Time.zone.today + 30.days,
                    status: 'in_progress')

      found_wave = described_class.find(wave.id)
      expect(found_wave.name).to eq("Test Wave")
      expect(found_wave.description).to eq("Wave description")
      expect(found_wave.status).to eq("in_progress")
      expect(found_wave.target_ship_date.to_date).to eq((Time.zone.today + 30.days).to_date)
    end

    it "updates a fulfillment wave" do
      wave = create(:fulfillment_wave, project: project, name: "Original Name", status: 'planned')

      expect(wave.update(name: "Updated Name", status: 'in_progress')).to be true
      wave.reload

      expect(wave.name).to eq("Updated Name")
      expect(wave.status).to eq("in_progress")
    end

    it "deletes a fulfillment wave" do
      wave = create(:fulfillment_wave, project: project)

      expect { wave.destroy }.to change(described_class, :count).by(-1)
    end

    it "deletes associated wave items when deleted" do
      wave = create(:fulfillment_wave, project: project)
      reward = create(:reward, project: project)
      reward_item = create(:reward_item, reward: reward)
      create(:wave_item, fulfillment_wave: wave, reward_item: reward_item)

      expect { wave.destroy }.to change(WaveItem, :count).by(-1)
    end
  end

  describe "integration with our Fulfillable concern" do
    let(:project) { create(:project) }
    let(:wave) { create(:fulfillment_wave, project: project, status: 'in_progress') }

    it "provides status_color method" do
      expect(wave.respond_to?(:status_color)).to be true
      expect(wave.status_color).to be_a(String)
    end

    it "handles fulfilled? method safely" do
      expect(wave.respond_to?(:fulfilled?)).to be true
      # The result might be false since we haven't defined fulfillment_progress
      # but the method shouldn't raise an error
      expect { wave.fulfilled? }.not_to raise_error
    end
  end
end
