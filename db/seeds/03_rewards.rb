puts "Creating rewards with varied fulfillment statuses..."

# Get project references
alien_project = Project.find_by(title: "ALIEN RPG - Evolved Edition")
game_project = Project.find_by(title: "Animation VERSUS - Fighting Game")
pan_project = Project.find_by(title: "The Misen Carbon Nonstick Pan")
wonderbox_project = Project.find_by(title: "WonderBox - Interactive Storytelling Game")
ecocharge_project = Project.find_by(title: "EcoCharge - Solar Powered Charging Station")
time_travel_project = Project.find_by(title: "Time Travel Documentary")

# ALIEN RPG Project Rewards - Active project, different statuses
if alien_project
  Reward.create!(
    project: alien_project,
    title: "Digital Core Rulebook",
    description: "PDF version of the ALIEN RPG core rulebook with all updates and errata incorporated.",
    amount: 25,
    estimated_delivery: Date.today + 1.month,
    status: Reward::STATUSES[:completed],
    fulfillment_progress: 100
  )

  Reward.create!(
    project: alien_project,
    title: "Hardcover Core Rulebook",
    description: "Physical hardcover edition of the ALIEN RPG core rulebook plus PDF version.",
    amount: 55,
    estimated_delivery: Date.today + 3.months,
    status: Reward::STATUSES[:in_transit],
    fulfillment_progress: 50
  )

  Reward.create!(
    project: alien_project,
    title: "Collector's Edition",
    description: "Limited edition hardcover with exclusive cover, dice set, GM screen, and all stretch goals. Includes PDF version.",
    amount: 120,
    estimated_delivery: Date.today + 4.months,
    status: Reward::STATUSES[:in_production],
    fulfillment_progress: 30
  )
end

# Animation VERSUS Game Rewards - Active project, early access
if game_project
  Reward.create!(
    project: game_project,
    title: "Early Access Digital Edition",
    description: "Digital download of the game with early access to beta builds and the final release.",
    amount: 25,
    estimated_delivery: Date.today + 2.months,
    status: Reward::STATUSES[:in_transit],
    fulfillment_progress: 80
  )

  Reward.create!(
    project: game_project,
    title: "Deluxe Digital Bundle",
    description: "Digital download of the game plus soundtrack, digital art book, and exclusive character skins.",
    amount: 45,
    estimated_delivery: Date.today + 3.months,
    status: Reward::STATUSES[:in_production],
    fulfillment_progress: 40
  )

  Reward.create!(
    project: game_project,
    title: "Collector's Physical Edition",
    description: "Physical collector's box with game download code, art book, soundtrack CD, and exclusive character figurine.",
    amount: 100,
    estimated_delivery: game_project.end_date + 14.months,
    status: Reward::STATUSES[:not_started],
    fulfillment_progress: 0
  )
end

# Misen Carbon Nonstick Pan Rewards - Active project, in production
if pan_project
  Reward.create!(
    project: pan_project,
    title: "Early Bird - 8\" Pan",
    description: "8-inch Misen Carbon Nonstick Pan at a special early bird price. Perfect for small dishes and single servings.",
    amount: 45,
    estimated_delivery: Date.today + 2.months,
    status: Reward::STATUSES[:in_production],
    fulfillment_progress: 40
  )

  Reward.create!(
    project: pan_project,
    title: "Standard - 10\" Pan",
    description: "10-inch Misen Carbon Nonstick Pan - our most versatile size for everyday cooking.",
    amount: 55,
    estimated_delivery: Date.today + 2.months,
    status: Reward::STATUSES[:in_production],
    fulfillment_progress: 30
  )

  Reward.create!(
    project: pan_project,
    title: "Complete Set",
    description: "The full Misen Carbon Nonstick collection: 8-inch, 10-inch, and 12-inch pans. Perfect for any cooking situation.",
    amount: 120,
    estimated_delivery: Date.today + 3.months,
    status: Reward::STATUSES[:in_production],
    fulfillment_progress: 15
  )
end

# Add rewards for WonderBox project
if wonderbox_project
  Reward.create!(
    project: wonderbox_project,
    title: "Standard Edition",
    description: "WonderBox standard edition with basic puzzle components and app access.",
    amount: 35,
    estimated_delivery: Date.today + 2.months,
    status: Reward::STATUSES[:not_started],
    fulfillment_progress: 0
  )

  Reward.create!(
    project: wonderbox_project,
    title: "Deluxe Wonderbox",
    description: "Enhanced edition with premium components, additional puzzles, and expanded narrative content.",
    amount: 95,
    estimated_delivery: Date.today + 1.month,
    status: Reward::STATUSES[:not_started],
    fulfillment_progress: 0
  )
end

# Add rewards for EcoCharge project (completed)
if ecocharge_project
  Reward.create!(
    project: ecocharge_project,
    title: "EcoCharge Basic",
    description: "Compact solar charging station with USB ports for smartphones and small devices.",
    amount: 65,
    estimated_delivery: Date.today - 2.months,
    status: Reward::STATUSES[:completed],
    fulfillment_progress: 100
  )

  Reward.create!(
    project: ecocharge_project,
    title: "EcoCharge Plus",
    description: "Multi-device charging station with expanded solar panel and higher capacity battery.",
    amount: 95,
    estimated_delivery: Date.today - 2.months,
    status: Reward::STATUSES[:completed],
    fulfillment_progress: 100
  )

  Reward.create!(
    project: ecocharge_project,
    title: "EcoCharge Pro",
    description: "Premium charging station with maximum capacity solar panels, LED lighting, and weather resistance.",
    amount: 145,
    estimated_delivery: Date.today - 1.month,
    status: Reward::STATUSES[:completed],
    fulfillment_progress: 100
  )
end

# Add rewards for other projects with varied statuses
[time_travel_project].compact.each do |project|
  # Basic Reward
  Reward.create!(
    project: project,
    title: "Digital Access",
    description: "Digital download or streaming access to the finished project.",
    amount: 15,
    estimated_delivery: project.end_date + 3.months,
    status: Reward::STATUSES[:not_started],
    fulfillment_progress: 0
  )
  
  # Standard Reward
  Reward.create!(
    project: project,
    title: "Standard Edition",
    description: "Physical copy or product plus digital access.",
    amount: 30,
    estimated_delivery: project.end_date + 4.months,
    status: Reward::STATUSES[:not_started],
    fulfillment_progress: 0
  )
  
  # Premium Reward
  Reward.create!(
    project: project,
    title: "Deluxe Edition",
    description: "Premium package with additional features, collectibles, or exclusive content.",
    amount: 75,
    estimated_delivery: project.end_date + 5.months,
    status: Reward::STATUSES[:not_started],
    fulfillment_progress: 0
  )
end

puts "Created #{Reward.count} rewards"
