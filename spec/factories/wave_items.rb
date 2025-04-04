FactoryBot.define do
  factory :wave_item do
    association :fulfillment_wave
    association :reward_item
    quantity { 5 }
  end
end
