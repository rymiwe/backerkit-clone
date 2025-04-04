require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "requires an email" do
      user = User.new(name: "Test User", password: "password")
      expect(user.valid?).to be false
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "requires a name" do
      user = User.new(email: "test@example.com", password: "password")
      expect(user.valid?).to be false
      expect(user.errors[:name]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "has many projects" do
      association = User.reflect_on_association(:projects)
      expect(association.macro).to eq :has_many
      expect(association.options[:foreign_key]).to eq 'creator_id'
    end

    it "has many pledges" do
      association = User.reflect_on_association(:pledges)
      expect(association.macro).to eq :has_many
    end
    
    it "has many backed projects through pledges" do
      association = User.reflect_on_association(:backed_projects)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :pledges
    end
  end
  
  describe "helper methods" do
    let(:user) { User.create(name: "Test User", email: "test@example.com", password: "password") }
    
    it "can be assigned a creator role" do
      user.make_creator
      expect(user.is_creator?).to be true
    end
    
    it "can be assigned a backer role" do
      user.make_backer
      expect(user.is_backer?).to be true
    end
  end
end
