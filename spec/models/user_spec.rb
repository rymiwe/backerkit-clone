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
    it "has many created_projects" do
      association = User.reflect_on_association(:created_projects)
      expect(association.macro).to eq :has_many
    end

    it "has many pledges" do
      association = User.reflect_on_association(:pledges)
      expect(association.macro).to eq :has_many
    end
  end
end
