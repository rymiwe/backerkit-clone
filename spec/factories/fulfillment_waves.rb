FactoryBot.define do
  factory :fulfillment_wave do
    association :project
    sequence(:name) { |n| "Wave #{n}" }
    description { "A fulfillment wave description" }
    target_ship_date { Date.today + 30.days }
    status { "planned" }
  end
end
