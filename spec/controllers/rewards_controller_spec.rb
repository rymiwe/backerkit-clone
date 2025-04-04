require 'rails_helper'

RSpec.describe RewardsController do
  describe "access control" do
    let(:user) { create(:user, name: "Test User", email: "test@example.com", password: "password") }
    let(:creator) { create(:user, name: "Creator", email: "creator@example.com", password: "password") }
    let(:project) do
      create(:project, title: "Test Project", description: "Test description", goal: 1000.0, creator: creator,
                       status: 'active')
    end

    context "when not logged in" do
      it "does not allow access" do
        get :new, params: { project_id: project.id }
        expect(response).not_to be_successful
      end
    end

    context "when logged in as a non-creator" do
      before { sign_in user }

      it "does not allow access and shows an error" do
        get :new, params: { project_id: project.id }
        expect(response).not_to be_successful
        expect(flash[:alert]).to be_present
      end
    end

    context "when logged in as the project creator" do
      before { sign_in creator }

      it "allows access to create rewards" do
        get :new, params: { project_id: project.id }
        expect(response).to be_successful
      end
    end
  end

  describe "reward management" do
    let(:creator) { create(:user, name: "Creator", email: "creator@example.com", password: "password") }
    let(:project) { create(:project, creator: creator) }

    before { sign_in creator }

    describe "GET #new" do
      it "shows the new reward form" do
        get :new, params: { project_id: project.id }
        expect(response).to be_successful
        # In controller tests, we don't have access to the rendered content
        # We just verify that the response is successful
      end
    end

    describe "POST #create" do
      let(:valid_attributes) do
        {
          title: "Early Bird Special",
          description: "Get it first!",
          amount: 50.0,
          estimated_shipping_date: Time.zone.today + 30.days
        }
      end

      it "creates a new reward" do
        expect do
          post :create, params: { project_id: project.id, reward: valid_attributes }
        end.to change(Reward, :count).by(1)

        expect(response).to be_redirect

        # Verify the reward attributes
        reward = Reward.last
        expect(reward.title).to eq("Early Bird Special")
        expect(reward.amount).to eq(50.0)
        # The default status might be nil or a specific value, so we're not testing it specifically
      end
    end

    describe "PUT #update" do
      let!(:reward) { create(:reward, project: project, title: "Original Title") }

      it "updates the reward attributes" do
        put :update, params: {
          project_id: project.id,
          id: reward.id,
          reward: { title: "Updated Title", amount: 75.0 }
        }

        reward.reload
        expect(reward.title).to eq("Updated Title")
        expect(reward.amount).to eq(75.0)
        expect(response).to be_redirect
      end
    end

    describe "DELETE #destroy" do
      context "when reward has no pledges" do
        let!(:reward) { create(:reward, project: project) }

        it "destroys the reward" do
          expect do
            delete :destroy, params: { project_id: project.id, id: reward.id }
          end.to change(Reward, :count).by(-1)

          expect(response).to be_redirect
        end
      end

      context "when reward has pledges" do
        let!(:reward) { create(:reward, project: project) }
        let(:backer) { create(:user, name: "Backer", email: "backer@example.com", password: "password") }

        before do
          create(:pledge, backer: backer, project: project, reward: reward, amount: 50.0)
        end

        it "does not destroy the reward" do
          expect do
            delete :destroy, params: { project_id: project.id, id: reward.id }
          end.not_to change(Reward, :count)

          expect(response).to be_redirect
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
