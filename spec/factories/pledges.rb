FactoryBot.define do
  factory :pledge do
    amount { 50.00 }
    association :backer, factory: :user
    association :project
    
    # Don't automatically create a reward for every pledge
    # as reward is optional in the model
    reward { nil }
    
    # Define a trait for pledges with rewards
    trait :with_reward do
      association :reward
    end
  end
end
