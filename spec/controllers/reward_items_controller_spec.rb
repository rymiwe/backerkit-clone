require 'rails_helper'

RSpec.describe RewardItemsController, type: :controller do
  let(:creator) { create(:user, name: "Creator", email: "creator@example.com", password: "password") }
  let(:user) { create(:user, name: "Test User", email: "test@example.com", password: "password") }
  let(:project) { create(:project, title: "Test Project", description: "Test description", goal: 1000.0, creator: creator, status: 'active') }
  let(:reward) { create(:reward, project: project, title: "Basic Reward", description: "A basic reward", amount: 50.0) }
  
  describe "access control" do
    context "when not logged in" do
      it "does not allow access" do
        get :new, params: { project_id: project.id, reward_id: reward.id }
        expect(response).not_to be_successful
      end
    end
    
    context "when logged in as a non-creator" do
      before { sign_in user }
      
      it "does not allow access and shows an error" do
        get :new, params: { project_id: project.id, reward_id: reward.id }
        expect(response).not_to be_successful
        expect(flash[:alert]).to be_present
      end
    end
    
    context "when logged in as the project creator" do
      before { sign_in creator }
      
      it "allows access to manage reward items" do
        get :new, params: { project_id: project.id, reward_id: reward.id }
        expect(response).to be_successful
      end
    end
  end
  
  describe "reward items CRUD operations" do
    before { sign_in creator }
    
    describe "GET #new" do
      it "shows the new reward item form" do
        get :new, params: { project_id: project.id, reward_id: reward.id }
        expect(response).to be_successful
      end
    end
    
    describe "POST #create" do
      let(:valid_attributes) {
        { 
          name: "Test Item",
          description: "A test item for the reward",
          quantity_per_reward: 1,
          production_priority: 2
        }
      }
      
      it "creates a new reward item" do
        expect {
          post :create, params: { project_id: project.id, reward_id: reward.id, reward_item: valid_attributes }
        }.to change(RewardItem, :count).by(1)
        
        expect(response).to be_redirect
        
        # Verify the item attributes
        item = RewardItem.last
        expect(item.name).to eq("Test Item")
        expect(item.quantity_per_reward).to eq(1)
        expect(item.production_priority).to eq(2)
        
        # Verify total_needed is calculated based on pledges
        expect(item.total_needed).to eq(0) # No pledges yet
      end
    end
    
    describe "GET #edit" do
      let!(:reward_item) { create(:reward_item, reward: reward, name: "Test Item", quantity_per_reward: 1) }
      
      it "shows the edit form for the reward item" do
        get :edit, params: { project_id: project.id, reward_id: reward.id, id: reward_item.id }
        expect(response).to be_successful
      end
    end
    
    describe "PUT #update" do
      let!(:reward_item) { create(:reward_item, reward: reward, name: "Original Name", quantity_per_reward: 1) }
      
      it "updates the reward item attributes" do
        put :update, params: {
          project_id: project.id,
          reward_id: reward.id,
          id: reward_item.id,
          reward_item: { 
            name: "Updated Name", 
            description: "Updated description",
            quantity_per_reward: 2,
            production_priority: 3
          }
        }
        
        reward_item.reload
        expect(reward_item.name).to eq("Updated Name")
        expect(reward_item.quantity_per_reward).to eq(2)
        expect(reward_item.production_priority).to eq(3)
        
        expect(response).to be_redirect
      end
    end
    
    describe "DELETE #destroy" do
      let!(:reward_item) { create(:reward_item, reward: reward, name: "Test Item", quantity_per_reward: 1) }
      
      it "destroys the reward item when there are no fulfillment records" do
        expect {
          delete :destroy, params: { project_id: project.id, reward_id: reward.id, id: reward_item.id }
        }.to change(RewardItem, :count).by(-1)
        
        expect(response).to be_redirect
      end
      
      context "when reward item has fulfillment records" do
        let(:backer) { create(:user, name: "Backer", email: "backer@example.com", password: "password") }
        let!(:pledge) { create(:pledge, backer: backer, project: project, reward: reward, amount: 50.0) }
        let!(:backer_fulfillment) { create(:backer_item_fulfillment, reward_item: reward_item, pledge: pledge, shipped: false) }
        
        it "does not allow deletion" do
          expect {
            delete :destroy, params: { project_id: project.id, reward_id: reward.id, id: reward_item.id }
          }.not_to change(RewardItem, :count)
          
          expect(response).to be_redirect
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
