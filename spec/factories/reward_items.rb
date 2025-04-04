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
    
    trait :half_produced do
      total_needed { 20 }
      produced_count { 10 }
      shipped_count { 0 }
    end
    
    trait :half_shipped do
      total_needed { 20 }
      produced_count { 20 }
      shipped_count { 10 }
    end
    
    trait :ready do
      total_needed { 10 }
      produced_count { 10 }
      shipped_count { 0 }
    end
    
    trait :in_progress do
      total_needed { 10 }
      produced_count { 5 }
      shipped_count { 0 }
    end
    
    trait :not_started do
      total_needed { 10 }
      produced_count { 0 }
      shipped_count { 0 }
    end
  end
end
