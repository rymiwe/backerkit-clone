FactoryBot.define do
  factory :reward_item do
    association :reward
    sequence(:name) { |n| "Item #{n}" }
    description { "A reward item description" }
    quantity_per_reward { 1 }
    total_needed { 10 }
    produced_count { 0 }
    shipped_count { 0 }
    # production_priority attribute removed - not in model schema
  end
end
