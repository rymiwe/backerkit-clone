namespace :db do
  desc "Seed fulfillment waves data for demonstration"
  task seed_fulfillment_waves: :environment do
    load Rails.root.join('db', 'seeds', 'fulfillment_waves.rb')
  end
end
