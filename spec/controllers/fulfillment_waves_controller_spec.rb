require 'rails_helper'

RSpec.describe FulfillmentWavesController do
  let(:creator) { create(:user, name: "Creator", email: "creator@example.com", password: "password") }
  let(:user) { create(:user, name: "Test User", email: "test@example.com", password: "password") }
  let(:project) do
    create(:project, title: "Test Project", description: "Test description", goal: 1000.0, creator: creator,
                     status: 'active')
  end
  let(:reward) { create(:reward, project: project, title: "Basic Reward", description: "A basic reward", amount: 50.0) }
  let!(:reward_item) do
    create(:reward_item, reward: reward, name: "Test Item", quantity_per_reward: 1, produced_count: 0, shipped_count: 0,
                         total_needed: 10)
  end

  describe "access control" do
    context "when not logged in" do
      it "does not allow access" do
        get :index, params: { project_id: project.id }
        expect(response).not_to be_successful
      end
    end

    context "when logged in as a non-creator" do
      before { sign_in user }

      it "does not allow access and shows an error" do
        get :index, params: { project_id: project.id }
        expect(response).not_to be_successful
        expect(flash[:alert]).to be_present
      end
    end

    context "when logged in as the project creator" do
      before { sign_in creator }

      it "allows access to fulfillment waves" do
        get :index, params: { project_id: project.id }
        expect(response).to be_successful
      end
    end
  end

  describe "fulfillment waves CRUD operations" do
    before { sign_in creator }

    describe "GET #index" do
      it "displays the list of fulfillment waves" do
        get :index, params: { project_id: project.id }
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "shows the new fulfillment wave form" do
        get :new, params: { project_id: project.id }
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      let(:valid_attributes) do
        {
          name: "Wave 1",
          description: "First production wave",
          target_ship_date: Time.zone.today + 30.days,
          status: "planned",
          item_ids: [reward_item.id.to_s],
          quantity_map: { reward_item.id.to_s => "5" }
        }
      end

      it "creates a new fulfillment wave" do
        expect do
          post :create, params: { project_id: project.id, fulfillment_wave: valid_attributes }
        end.to change(FulfillmentWave, :count).by(1)

        expect(response).to be_redirect

        # Verify the wave attributes
        wave = FulfillmentWave.last
        expect(wave.name).to eq("Wave 1")
        expect(wave.status).to eq("planned")
        expect(wave.target_ship_date.to_date).to eq((Time.zone.today + 30.days).to_date)

        # Verify wave items are created
        expect(wave.wave_items.count).to eq(1)
        expect(wave.wave_items.first.reward_item_id).to eq(reward_item.id)
        expect(wave.wave_items.first.quantity).to eq(5)
      end
    end

    describe "GET #show" do
      let!(:wave) do
        create(:fulfillment_wave, project: project, name: "Test Wave", status: "planned",
                                  target_ship_date: Time.zone.today + 30.days)
      end
      let!(:original_wave_item) { create(:wave_item, fulfillment_wave: wave, reward_item: reward_item, quantity: 5) }

      it "shows the fulfillment wave details" do
        get :show, params: { project_id: project.id, id: wave.id }
        expect(response).to be_successful
      end
    end

    describe "GET #edit" do
      let!(:wave) do
        create(:fulfillment_wave, project: project, name: "Test Wave", status: "planned",
                                  target_ship_date: Time.zone.today + 30.days)
      end

      it "shows the edit form for the fulfillment wave" do
        get :edit, params: { project_id: project.id, id: wave.id }
        expect(response).to be_successful
      end
    end

    describe "PUT #update" do
      let!(:wave) do
        create(:fulfillment_wave, project: project, name: "Original Name", status: "planned",
                                  target_ship_date: Time.zone.today + 30.days)
      end
      let!(:original_wave_item) { create(:wave_item, fulfillment_wave: wave, reward_item: reward_item, quantity: 5) }

      it "updates the fulfillment wave attributes" do
        put :update, params: {
          project_id: project.id,
          id: wave.id,
          fulfillment_wave: {
            name: "Updated Name",
            status: "in_progress",
            target_ship_date: Time.zone.today + 45.days,
            item_ids: [reward_item.id.to_s],
            quantity_map: { reward_item.id.to_s => "8" }
          }
        }

        wave.reload
        expect(wave.name).to eq("Updated Name")
        expect(wave.status).to eq("in_progress")
        expect(wave.target_ship_date.to_date).to eq((Time.zone.today + 45.days).to_date)

        # Verify wave item is updated - we need to get the new wave item
        # since our controller destroys the old ones and creates new ones
        new_wave_item = wave.wave_items.where(reward_item_id: reward_item.id).first
        expect(new_wave_item).to be_present
        expect(new_wave_item.quantity).to eq(8)

        expect(response).to be_redirect
      end
    end

    describe "DELETE #destroy" do
      let!(:wave) do
        create(:fulfillment_wave, project: project, name: "Test Wave", status: "planned",
                                  target_ship_date: Time.zone.today + 30.days)
      end

      it "destroys the fulfillment wave" do
        expect do
          delete :destroy, params: { project_id: project.id, id: wave.id }
        end.to change(FulfillmentWave, :count).by(-1)

        expect(response).to be_redirect
      end

      context "when wave has started shipping" do
        let!(:shipping_wave) do
          create(:fulfillment_wave, project: project, name: "Shipping Wave", status: "shipping",
                                    target_ship_date: Time.zone.today + 30.days)
        end

        it "does not allow deletion" do
          expect do
            delete :destroy, params: { project_id: project.id, id: shipping_wave.id }
          end.not_to change(FulfillmentWave, :count)

          expect(response).to be_redirect
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
