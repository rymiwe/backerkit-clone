FactoryBot.define do
  factory :reward do
    sequence(:title) { |n| "Reward #{n}" }
    description { "A test reward description" }
    amount { 25.00 }
    estimated_delivery { 2.months.from_now }
    status { "not_started" }
    fulfillment_progress { 0 }
    association :project
  end
end
