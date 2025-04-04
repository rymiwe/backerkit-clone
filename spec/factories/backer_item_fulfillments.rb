FactoryBot.define do
  factory :backer_item_fulfillment do
    association :pledge
    association :reward_item
    shipped { false }
    tracking_number { nil }
    tracking_url { nil }
    notes { nil }
  end
end
