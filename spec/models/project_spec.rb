require 'rails_helper'

RSpec.describe Project do
  describe "validations" do
    it "requires a title" do
      project = described_class.new(description: "Test description", goal: 100.0)
      expect(project.valid?).to be false
      expect(project.errors[:title]).to include("can't be blank")
    end

    it "requires a description" do
      project = described_class.new(title: "Test Project", goal: 100.0)
      expect(project.valid?).to be false
      expect(project.errors[:description]).to include("can't be blank")
    end

    it "requires a goal" do
      project = described_class.new(title: "Test Project", description: "Test description")
      expect(project.valid?).to be false
      expect(project.errors[:goal]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "belongs to a creator" do
      association = described_class.reflect_on_association(:creator)
      expect(association.macro).to eq :belongs_to
    end

    it "has many rewards" do
      association = described_class.reflect_on_association(:rewards)
      expect(association.macro).to eq :has_many
    end

    it "has many pledges" do
      association = described_class.reflect_on_association(:pledges)
      expect(association.macro).to eq :has_many
    end
  end

  describe "status methods" do
    let(:creator) { User.create(name: "Creator", email: "creator@example.com", password: "password") }
    let(:project) do
      described_class.create(title: "Test Project", description: "Test description", goal: 1000.0, creator: creator,
                             status: 'draft', end_date: 1.month.from_now)
    end

    it "can be set to different statuses" do
      expect(project.status).to eq('draft')

      project.update(status: 'active')
      expect(project.status).to eq('active')

      project.update(status: 'completed')
      expect(project.status).to eq('completed')
    end

    it "can calculate funded percentage" do
      backer = User.create(name: "Backer", email: "backer@example.com", password: "password")
      Pledge.create(backer: backer, project: project, amount: 200.0)

      expect(project.funded_percentage).to eq(20) # 200/1000 = 20%
    end

    it "can calculate total backers" do
      backer1 = User.create(name: "Backer 1", email: "backer1@example.com", password: "password")
      backer2 = User.create(name: "Backer 2", email: "backer2@example.com", password: "password")

      Pledge.create(backer: backer1, project: project, amount: 100.0)
      Pledge.create(backer: backer2, project: project, amount: 200.0)

      expect(project.total_backers).to eq(2)
    end

    it "can calculate days remaining" do
      expect(project.days_remaining).to be > 0

      past_project = described_class.create(
        title: "Past Project",
        description: "Past description",
        goal: 1000.0,
        creator: creator,
        end_date: 1.day.ago
      )

      expect(past_project.days_remaining).to eq(0)
    end
  end
end
