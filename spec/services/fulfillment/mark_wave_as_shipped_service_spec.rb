require 'rails_helper'

RSpec.describe Fulfillment::MarkWaveAsShippedService do
  # Create a user with the creator role
  let(:creator) do 
    user = create(:user)
    user.make_creator # Add the creator role
    user
  end
  
  let(:project) { create(:project, creator: creator) }
  let(:backer) { create(:user) }
  let(:reward) { create(:reward, project: project) }
  let(:reward_item) { create(:reward_item, reward: reward, quantity_per_reward: 1, produced_count: 10) }
  let(:pledge) { create(:pledge, backer: backer, project: project, reward: reward) }
  
  let(:wave) do
    create(:fulfillment_wave, 
      project: project, 
      status: 'in_progress', 
      target_ship_date: Time.zone.today + 30.days
    )
  end
  
  let!(:wave_item) do
    create(:wave_item, 
      fulfillment_wave: wave, 
      reward_item: reward_item, 
      quantity: 5
    )
  end
  
  subject(:service) { described_class.new(wave, creator) }

  describe '#call' do
    before do
      pledge # Create the pledge
    end

    context 'when the user is the project creator' do
      it 'returns true on successful completion' do
        expect(service.call).to be true
      end

      it 'updates the wave status to shipping' do
        service.call
        expect(wave.reload.status).to eq('shipping')
      end

      it 'updates shipping counts on reward items' do
        expect { service.call }.to change { reward_item.reload.shipped_count }.from(0).to(5)
      end

      it 'creates shipping records for all related pledges' do
        expect { service.call }.to change { BackerItemFulfillment.count }.by(1)
        
        fulfillment = BackerItemFulfillment.last
        expect(fulfillment.pledge).to eq(pledge)
        expect(fulfillment.reward_item).to eq(reward_item)
        expect(fulfillment.shipped).to be true
      end
    end

    context 'when the user is an admin' do
      let(:admin) { create(:user, roles: ['admin']) }
      subject(:service) { described_class.new(wave, admin) }

      it 'allows admins to mark waves as shipped' do
        expect(service.call).to be true
      end
    end

    context 'when the user is not authorized' do
      let(:random_user) { create(:user) }
      subject(:service) { described_class.new(wave, random_user) }

      it 'returns false' do
        expect(service.call).to be false
      end

      it 'does not update the wave status' do
        service.call
        expect(wave.reload.status).to eq('in_progress')
      end
    end

    context 'when the wave is already shipped' do
      let(:wave) do
        create(:fulfillment_wave, 
          project: project, 
          status: 'shipping', 
          target_ship_date: Time.zone.today + 30.days
        )
      end

      it 'does not update the wave status again' do
        expect { service.call }.not_to change { wave.reload.status }
      end
    end

    context 'when the wave is already completed' do
      let(:wave) do
        create(:fulfillment_wave, 
          project: project, 
          status: 'completed', 
          target_ship_date: Time.zone.today + 30.days
        )
      end

      it 'does not update the wave status again' do
        expect { service.call }.not_to change { wave.reload.status }
      end
    end

    context 'when an error occurs during processing' do
      before do
        allow(wave).to receive(:update!).and_raise(StandardError, "Test error")
      end

      it 'returns false' do
        expect(service.call).to be false
      end

      it 'logs the error' do
        expect(Rails.logger).to receive(:error).with("Error shipping wave: Test error")
        service.call
      end
    end

    context 'with multiple pledges and reward items' do
      let(:backer2) { create(:user) }
      let(:backer3) { create(:user) }
      let(:pledge2) { create(:pledge, backer: backer2, project: project, reward: reward) }
      let(:pledge3) { create(:pledge, backer: backer3, project: project, reward: reward) }
      
      let(:reward_item2) { create(:reward_item, reward: reward, quantity_per_reward: 1, produced_count: 15) }
      
      let!(:wave_item2) do
        create(:wave_item, 
          fulfillment_wave: wave, 
          reward_item: reward_item2, 
          quantity: 10
        )
      end
      
      before do
        pledge2
        pledge3
      end

      it 'creates shipping records for all backers that have pledged for the reward' do
        expect { service.call }.to change { BackerItemFulfillment.count }.by(6) # 3 backers x 2 items
      end

      it 'updates shipping counts correctly for all reward items' do
        service.call
        expect(reward_item.reload.shipped_count).to eq(5)
        expect(reward_item2.reload.shipped_count).to eq(10)
      end
    end
  end
end
