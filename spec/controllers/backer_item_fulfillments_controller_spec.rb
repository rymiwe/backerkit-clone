require 'rails_helper'

RSpec.describe BackerItemFulfillmentsController do
  let(:creator) { create(:user, name: "Creator", email: "creator@example.com", password: "password") }
  let(:backer) { create(:user, name: "Backer", email: "backer@example.com", password: "password") }
  let(:project) do
    create(:project, title: "Test Project", description: "Test description", goal: 1000.0, creator: creator,
                     status: 'active')
  end
  let(:reward) { create(:reward, project: project, title: "Basic Reward", description: "A basic reward", amount: 50.0) }
  let!(:reward_item) do
    create(:reward_item, reward: reward, name: "Test Item", quantity_per_reward: 1, produced_count: 10, shipped_count: 0,
                         total_needed: 10)
  end
  let!(:pledge) { create(:pledge, backer: backer, project: project, reward: reward, amount: 50.0) }

  describe "access control" do
    context "when not logged in" do
      it "does not allow access" do
        get :index, params: { project_id: project.id, pledge_id: pledge.id }
        expect(response).not_to be_successful
      end
    end

    context "when logged in as a non-creator" do
      before { sign_in backer }

      it "allows backers to view their own fulfillment status but not update it" do
        get :index, params: { project_id: project.id, pledge_id: pledge.id }
        expect(response).to be_successful

        # But they can't update
        fulfillment = create(:backer_item_fulfillment, reward_item: reward_item, pledge: pledge, shipped: false)
        put :update, params: {
          project_id: project.id,
          pledge_id: pledge.id,
          id: fulfillment.id,
          backer_item_fulfillment: { shipped: true }
        }
        expect(response).not_to be_successful
      end
    end

    context "when logged in as the project creator" do
      before { sign_in creator }

      it "allows full access to manage backer fulfillments" do
        get :index, params: { project_id: project.id, pledge_id: pledge.id }
        expect(response).to be_successful
      end
    end
  end

  describe "fulfillment CRUD operations" do
    before { sign_in creator }

    describe "GET #index" do
      it "displays the list of backer fulfillments for a pledge" do
        get :index, params: { project_id: project.id, pledge_id: pledge.id }
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it "creates a new backer item fulfillment" do
        expect do
          post :create, params: {
            project_id: project.id,
            pledge_id: pledge.id,
            backer_item_fulfillment: { reward_item_id: reward_item.id, shipped: false }
          }
        end.to change(BackerItemFulfillment, :count).by(1)

        expect(response).to be_redirect

        # Verify the fulfillment attributes
        fulfillment = BackerItemFulfillment.last
        expect(fulfillment.reward_item_id).to eq(reward_item.id)
        expect(fulfillment.pledge_id).to eq(pledge.id)
        expect(fulfillment.shipped).to be(false)
      end
    end

    describe "PUT #update" do
      let!(:fulfillment) { create(:backer_item_fulfillment, reward_item: reward_item, pledge: pledge, shipped: false) }

      it "updates the fulfillment status" do
        put :update, params: {
          project_id: project.id,
          pledge_id: pledge.id,
          id: fulfillment.id,
          backer_item_fulfillment: { shipped: true }
        }

        fulfillment.reload
        expect(fulfillment.shipped).to be(true)

        # It should also update the shipped count on the reward item
        reward_item.reload
        expect(reward_item.shipped_count).to be > 0

        expect(response).to be_redirect
      end

      it "handles bulk updates for multiple backers" do
        # Create a second backer and pledge
        backer2 = create(:user, name: "Backer 2", email: "backer2@example.com", password: "password")
        pledge2 = create(:pledge, backer: backer2, project: project, reward: reward, amount: 50.0)
        fulfillment2 = create(:backer_item_fulfillment, reward_item: reward_item, pledge: pledge2, shipped: false)

        put :bulk_update, params: {
          project_id: project.id,
          fulfillment_ids: [fulfillment.id, fulfillment2.id],
          shipped: true
        }

        fulfillment.reload
        fulfillment2.reload
        expect(fulfillment.shipped).to be(true)
        expect(fulfillment2.shipped).to be(true)

        # It should also update the shipped count on the reward item
        reward_item.reload
        expect(reward_item.shipped_count).to be >= 2

        expect(response).to be_redirect
      end
    end

    describe "DELETE #destroy" do
      let!(:fulfillment) { create(:backer_item_fulfillment, reward_item: reward_item, pledge: pledge, shipped: false) }

      it "destroys the fulfillment record when it hasn't been shipped" do
        expect do
          delete :destroy, params: { project_id: project.id, pledge_id: pledge.id, id: fulfillment.id }
        end.to change(BackerItemFulfillment, :count).by(-1)

        expect(response).to be_redirect
      end

      context "when fulfillment has been shipped" do
        let!(:shipped_fulfillment) do
          create(:backer_item_fulfillment, reward_item: reward_item, pledge: pledge, shipped: true)
        end

        it "does not allow deletion of shipped records" do
          expect do
            delete :destroy, params: { project_id: project.id, pledge_id: pledge.id, id: shipped_fulfillment.id }
          end.not_to change(BackerItemFulfillment, :count)

          expect(response).to be_redirect
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
