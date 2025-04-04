require 'rails_helper'

RSpec.describe FulfillmentDashboardController, type: :controller do
  describe "access control" do
    let(:user) { User.create(name: "Test User", email: "test@example.com", password: "password") }
    let(:creator) { User.create(name: "Creator", email: "creator@example.com", password: "password") }
    let(:project) { Project.create(title: "Test Project", description: "Test description", goal: 1000.0, creator: creator, status: 'active') }
    
    context "when not logged in" do
      it "redirects to login page" do
        get :index, params: { project_id: project.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    
    context "when logged in as a non-creator" do
      before { sign_in user }
      
      it "redirects with an access denied message" do
        get :index, params: { project_id: project.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to include("access")
      end
    end
    
    context "when logged in as the project creator" do
      before { sign_in creator }
      
      it "allows access to the fulfillment dashboard" do
        get :index, params: { project_id: project.id }
        expect(response).to be_successful
      end
    end
  end
  
  describe "dashboard functionality" do
    let(:creator) { User.create(name: "Creator", email: "creator@example.com", password: "password") }
    let(:backer1) { User.create(name: "Backer 1", email: "backer1@example.com", password: "password") }
    let(:backer2) { User.create(name: "Backer 2", email: "backer2@example.com", password: "password") }
    let(:project) { Project.create(title: "Test Project", description: "Test description", goal: 1000.0, creator: creator, status: 'active') }
    let!(:reward1) { Reward.create(title: "Early Bird", description: "First reward", amount: 50.0, project: project) }
    let!(:reward2) { Reward.create(title: "Deluxe", description: "Premium reward", amount: 150.0, project: project) }
    
    before do
      sign_in creator
      Pledge.create(user: backer1, project: project, reward: reward1, amount: 50.0)
      Pledge.create(user: backer2, project: project, reward: reward2, amount: 150.0)
    end
    
    it "displays all project rewards with fulfillment status" do
      get :index, params: { project_id: project.id }
      expect(assigns(:rewards)).to include(reward1, reward2)
    end
    
    it "shows overall fulfillment progress" do
      reward1.update(fulfillment_status: 'fulfilled', fulfillment_progress: 100)
      get :index, params: { project_id: project.id }
      expect(assigns(:overall_progress)).to eq(50) # One of two rewards fulfilled = 50%
    end
    
    describe "updating fulfillment status" do
      it "updates a reward's fulfillment status" do
        shipping_date = Date.today + 30.days
        put :update_status, params: {
          project_id: project.id,
          reward_id: reward1.id,
          reward: {
            fulfillment_status: 'in_progress',
            fulfillment_progress: 75,
            estimated_delivery: shipping_date
          }
        }
        
        reward1.reload
        expect(reward1.fulfillment_status).to eq('in_progress')
        expect(reward1.fulfillment_progress).to eq(75)
        expect(reward1.estimated_delivery).to eq(shipping_date)
      end
      
      it "redirects back to the dashboard after update" do
        put :update_status, params: {
          project_id: project.id,
          reward_id: reward1.id,
          reward: {
            fulfillment_status: 'fulfilled',
            fulfillment_progress: 100
          }
        }
        
        expect(response).to redirect_to(project_fulfillment_dashboard_index_path(project))
      end
    end
  end
end
