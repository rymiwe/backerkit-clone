FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }
    description { "A test project description" }
    goal { 10000.00 }
    end_date { 30.days.from_now }
    category { "Technology" }
    association :creator, factory: :user
  end
end
