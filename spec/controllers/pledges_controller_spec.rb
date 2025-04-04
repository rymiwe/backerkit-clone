require 'rails_helper'

RSpec.describe PledgesController, type: :controller do
  let(:creator) { create(:user) }
  let(:backer) { create(:user) }
  let(:project) { create(:project, creator: creator) }
  let(:reward) { create(:reward, project: project, amount: 50) }
  
  describe "GET #new" do
    context "when logged in" do
      before { sign_in backer }
      
      it "renders the new pledge form" do
        get :new, params: { project_id: project.id }
        expect(response).to be_successful
      end

      context "when a reward is selected" do
        it "assigns the reward and sets the minimum amount" do
          get :new, params: { project_id: project.id, reward_id: reward.id }
          expect(assigns(:reward)).to eq(reward)
          expect(assigns(:pledge).amount).to eq(50) # Should match the reward amount
        end
      end
    end
    
    context "when not logged in" do
      it "redirects to the login page" do
        get :new, params: { project_id: project.id }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST #create" do
    context "when logged in" do
      before { sign_in backer }
      
      context "with valid parameters" do
        context "with a reward" do
          it "creates a new pledge with the selected reward" do
            expect {
              post :create, params: { 
                project_id: project.id, 
                pledge: { 
                  amount: 50, 
                  reward_id: reward.id 
                } 
              }
            }.to change(Pledge, :count).by(1)

            expect(Pledge.last.reward).to eq(reward)
            expect(Pledge.last.amount).to eq(50)
            expect(response).to redirect_to(project_path(project))
          end
        end

        context "without a reward" do
          it "creates a new pledge with no reward" do
            expect {
              post :create, params: { 
                project_id: project.id, 
                pledge: { 
                  amount: 25, 
                  reward_id: "" 
                } 
              }
            }.to change(Pledge, :count).by(1)

            expect(Pledge.last.reward).to be_nil
            expect(Pledge.last.amount).to eq(25)
            expect(response).to redirect_to(project_path(project))
          end

          it "handles reward_id=0 correctly by setting it to nil" do
            expect {
              post :create, params: { 
                project_id: project.id, 
                pledge: { 
                  amount: 25, 
                  reward_id: "0" 
                } 
              }
            }.to change(Pledge, :count).by(1)

            expect(Pledge.last.reward).to be_nil
            expect(response).to redirect_to(project_path(project))
          end
        end
      end

      context "with invalid parameters" do
        it "does not create a pledge with negative amount" do
          expect {
            post :create, params: { 
              project_id: project.id, 
              pledge: { 
                amount: -10, 
                reward_id: reward.id 
              } 
            }
          }.not_to change(Pledge, :count)

          expect(response).to render_template(:new)
        end

        it "does not create a pledge with insufficient amount for reward" do
          expect {
            post :create, params: { 
              project_id: project.id, 
              pledge: { 
                amount: 10, 
                reward_id: reward.id  # Reward amount is 50
              } 
            }
          }.not_to change(Pledge, :count)

          expect(response).to render_template(:new)
          expect(assigns(:pledge).errors).to be_present
        end
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        post :create, params: { 
          project_id: project.id, 
          pledge: { 
            amount: 50, 
            reward_id: reward.id 
          } 
        }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET #index" do
    let!(:pledge) { create(:pledge, backer: backer, project: project, reward: reward) }
    
    context "when logged in" do
      before { sign_in backer }
      
      it "lists pledges for the current user" do
        get :index
        expect(response).to be_successful
        expect(assigns(:pledges)).to include(pledge)
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        get :index
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
