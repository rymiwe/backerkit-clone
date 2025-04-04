require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  describe "access control" do
    let(:user) { User.create(name: "Test User", email: "test@example.com", password: "password") }
    let(:creator) { User.create(name: "Creator", email: "creator@example.com", password: "password") }
    let(:project) { Project.create(title: "Test Project", description: "Test description", goal: 1000.0, creator: creator, status: 'active') }
    
    context "when not logged in" do
      it "redirects to login page" do
        get :new, params: { project_id: project.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    
    context "when logged in as a non-creator" do
      before { sign_in user }
      
      it "redirects with an access denied message" do
        get :new, params: { project_id: project.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to include("not authorized")
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
    let(:creator) { User.create(name: "Creator", email: "creator@example.com", password: "password") }
    let(:project) { Project.create(title: "Test Project", description: "Test description", goal: 1000.0, creator: creator, status: 'active') }
    
    before { sign_in creator }
    
    describe "GET #new" do
      it "renders the new template" do
        get :new, params: { project_id: project.id }
        expect(response).to render_template(:new)
      end
      
      it "assigns a new reward" do
        get :new, params: { project_id: project.id }
        expect(assigns(:reward)).to be_a_new(Reward)
      end
    end
    
    describe "POST #create" do
      let(:valid_attributes) { 
        { 
          title: "Test Reward", 
          description: "Test Description", 
          amount: 100.0,
          estimated_delivery: Date.today + 60.days
        } 
      }
      
      it "creates a new reward" do
        expect {
          post :create, params: { project_id: project.id, reward: valid_attributes }
        }.to change(Reward, :count).by(1)
      end
      
      it "redirects to the project page" do
        post :create, params: { project_id: project.id, reward: valid_attributes }
        expect(response).to redirect_to(project_path(project))
      end
      
      it "sets the fulfillment status to not_started by default" do
        post :create, params: { project_id: project.id, reward: valid_attributes }
        expect(Reward.last.fulfillment_status).to eq('not_started')
      end
    end
    
    describe "PUT #update" do
      let!(:reward) { Reward.create(title: "Original Reward", description: "Original Description", amount: 50.0, project: project) }
      
      it "updates reward attributes" do
        put :update, params: { 
          project_id: project.id, 
          id: reward.id, 
          reward: { 
            title: "Updated Reward", 
            description: "Updated Description",
            amount: 75.0
          } 
        }
        
        reward.reload
        expect(reward.title).to eq("Updated Reward")
        expect(reward.description).to eq("Updated Description")
        expect(reward.amount).to eq(75.0)
      end
      
      it "redirects to the project page" do
        put :update, params: { 
          project_id: project.id, 
          id: reward.id, 
          reward: { title: "Updated Reward" } 
        }
        
        expect(response).to redirect_to(project_path(project))
      end
    end
    
    describe "DELETE #destroy" do
      let!(:reward) { Reward.create(title: "Test Reward", description: "Test Description", amount: 50.0, project: project) }
      
      context "when reward has no pledges" do
        it "destroys the reward" do
          expect {
            delete :destroy, params: { project_id: project.id, id: reward.id }
          }.to change(Reward, :count).by(-1)
        end
      end
      
      context "when reward has pledges" do
        let(:backer) { User.create(name: "Backer", email: "backer@example.com", password: "password") }
        
        before do
          Pledge.create(user: backer, project: project, reward: reward, amount: 50.0)
        end
        
        it "does not destroy the reward" do
          expect {
            delete :destroy, params: { project_id: project.id, id: reward.id }
          }.not_to change(Reward, :count)
        end
        
        it "redirects with an error message" do
          delete :destroy, params: { project_id: project.id, id: reward.id }
          expect(flash[:alert]).to include("Cannot delete reward with pledges")
        end
      end
    end
  end
end
