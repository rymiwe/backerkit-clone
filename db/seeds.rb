# This file seeds the database with realistic sample data for the BackerKit clone
# Run with: bin/rails db:seed

puts "Cleaning the database..."
# Clear existing data to avoid duplicates
Pledge.destroy_all
Reward.destroy_all
Project.destroy_all
User.destroy_all

# Temporarily disable shipping validation during seed process
ENV['SKIP_SHIPPING_VALIDATION'] = 'true'
puts "Shipping validation disabled for seeding"

puts "Creating users..."
# Create admin user
admin = User.create!(
  name: "Admin User",
  email: "admin@example.com",
  password: "password",
  roles: ["creator", "backer"]
)

# Create sample users with realistic names
users = [
  User.create!(name: "Sarah Johnson", email: "sarah@example.com", password: "password", roles: ["creator", "backer"]),
  User.create!(name: "Michael Chen", email: "michael@example.com", password: "password", roles: ["creator", "backer"]),
  User.create!(name: "Emma Rodriguez", email: "emma@example.com", password: "password", roles: ["creator", "backer"]),
  User.create!(name: "David Kim", email: "david@example.com", password: "password", roles: ["creator", "backer"]),
  User.create!(name: "Olivia Williams", email: "olivia@example.com", password: "password", roles: ["creator", "backer"]),
  User.create!(name: "James Miller", email: "james@example.com", password: "password", roles: ["creator", "backer"]),
  User.create!(name: "Sophia Garcia", email: "sophia@example.com", password: "password", roles: ["creator", "backer"]),
  User.create!(name: "Ethan Brown", email: "ethan@example.com", password: "password", roles: ["creator", "backer"]),
  User.create!(name: "Ava Martinez", email: "ava@example.com", password: "password", roles: ["creator", "backer"]),
  User.create!(name: "Noah Wilson", email: "noah@example.com", password: "password", roles: ["creator", "backer"])
]

puts "Creating projects..."
# Project categories based on actual BackerKit categories
categories = ["Games", "Technology", "Design", "Comics", "Food", "Fashion", "Publishing", "Art", "Music", "Film & Video"]

# Create realistic projects based on actual BackerKit projects
projects = [
  # Games Projects
  Project.create!(
    title: "ALIEN RPG - Evolved Edition",
    description: "Expanded and updated core rules and a new cinematic scenario for the award-winning RPG from Free League and 20th Century Studios. In space, no one can hear you scream.\n\nThis new edition features refined rules, expanded lore, and stunning new artwork that captures the terror and beauty of the ALIEN universe. Perfect for both new players and veterans alike.",
    goal: 500000,
    end_date: Date.today + 15.days,
    creator: users[0],
    status: "active",
    image_url: "https://images.unsplash.com/photo-1607462109225-6b64ae2dd3cb?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Games"
  ),
  Project.create!(
    title: "Animation VERSUS - Fighting Game",
    description: "Animation VERSUS is a new fighting game featuring your favorite stick figure characters from animator Alan Becker! Experience the epic battles between the animator and his creations in this fast-paced 2D fighter.\n\nFeaturing unique characters, stunning animations, and intuitive controls, this game brings the beloved YouTube series to life in an interactive format.",
    goal: 130000,
    end_date: Date.today + 21.days,
    creator: users[1],
    status: "active",
    image_url: "https://images.unsplash.com/photo-1511512578047-dfb367046420?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Games"
  ),
  
  # Food Projects
  Project.create!(
    title: "The Misen Carbon Nonstick Pan",
    description: "Your pans have problems. We made something better. Introducing the safest, easiest, longest-lasting nonstick alternative on the market.\n\nThe Misen Carbon Nonstick Pan combines the best properties of carbon steel and nonstick cookware. It's naturally nonstick, incredibly durable, and completely PFAS-free. Perfect for everything from delicate eggs to high-heat searing.",
    goal: 25000,
    end_date: Date.today + 33.days,
    creator: users[2],
    status: "active",
    image_url: "https://images.unsplash.com/photo-1590794056226-79ef3a8147e1?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Food"
  ),
  
  # Technology Projects
  Project.create!(
    title: "QUBE: 3-in-1 Digital Angle, Level, Distance Meter",
    description: "The most accurately designed measurement tool ever created. Introducing QUBE, the must-have device for professionals and enthusiasts alike.\n\nQUBE combines the functionality of multiple tools in one sleek, portable design. Measure angles with digital precision, ensure perfect leveling, and calculate distances with the touch of a button.",
    goal: 50000,
    end_date: Date.today + 45.days,
    creator: users[4],
    status: "active",
    image_url: "https://images.unsplash.com/photo-1581091226033-d5c48150dbaa?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Technology"
  ),
  
  # Fashion Projects
  Project.create!(
    title: "The GAMEBAG - A Nostalgic, Fun ITA Satchel Bag",
    description: "Display your pins and patches in this high-quality satchel designed to showcase your collectibles!\n\nThe GAMEBAG features a transparent display window that allows you to show off your favorite pins, patches, and small collectibles. Made with premium materials and designed for everyday use, it's both functional and a conversation starter.",
    goal: 8000,
    end_date: Date.today + 18.days,
    creator: users[5],
    status: "active",
    image_url: "https://images.unsplash.com/photo-1556905055-8f358a7a47b2?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Fashion"
  ),
  
  # Comics Projects
  Project.create!(
    title: "The Goliath Chronicles: Limited Edition Hardcover",
    description: "The complete trilogy of the award-winning Goliath Chronicles in a stunning hardcover edition with exclusive new content.\n\nThis limited edition collection includes all three volumes of The Goliath Chronicles, plus 50 pages of never-before-seen artwork, character sketches, and author commentary. A must-have for fans of epic science fiction.",
    goal: 15000,
    end_date: Date.today + 30.days,
    creator: users[6],
    status: "active",
    image_url: "https://images.unsplash.com/photo-1588497859490-85d1c17db96d?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Comics"
  ),
  
  # Publishing Projects - Funded but still active
  Project.create!(
    title: "Blood Over Bright Haven - Illustrated Deluxe Edition",
    description: "A dark fantasy novel with stunning illustrations, premium binding, and exclusive content.\n\nSet in the haunted city of Bright Haven, this tale of vengeance and redemption comes to life with over 25 full-page illustrations by renowned artist Elena Mikhailov. This deluxe edition features a foil-stamped hardcover, ribbon bookmark, and exclusive short story not available in the standard edition.",
    goal: 20000,
    end_date: Date.today + 5.days,
    creator: users[8],
    status: "active",
    image_url: "https://images.unsplash.com/photo-1610890716171-6b1bb98ffd09?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Publishing"
  ),
  
  # Games Project - Funded and ended, in fulfillment
  Project.create!(
    title: "The Wonderbox of Alice - Puzzle Box Adventure",
    description: "An immersive puzzle experience inspired by Alice in Wonderland. Can you solve the riddles and escape Wonderland?\n\nThe Wonderbox of Alice is a premium physical puzzle box experience with interconnected components that reveal a narrative as you solve each challenge. Perfect for escape room enthusiasts and puzzle lovers.",
    goal: 10000,
    end_date: Date.today - 60.days,
    creator: users[9],
    status: "successful",
    image_url: "https://images.unsplash.com/photo-1611996575749-79a3a250f948?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Games"
  ),
  
  # Technology Project - Funded and fulfilled
  Project.create!(
    title: "EcoCharge - Solar Powered Charging Station",
    description: "A sustainable charging solution for all your devices, powered entirely by solar energy.\n\nEcoCharge combines elegant design with cutting-edge solar technology to create a charging station that works both indoors and outdoors. Features wireless charging, multiple USB ports, and a built-in battery for nighttime use.",
    goal: 30000,
    end_date: Date.today - 180.days,
    creator: users[7],
    status: "successful",
    image_url: "https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Technology"
  ),
  
  # Art Project - Failed funding
  Project.create!(
    title: "Urban Perspectives - Street Art Photography Book",
    description: "A photographic journey through the street art of 10 major global cities.\n\nThis large format art book documents the vibrant street art scenes of cities like Berlin, São Paulo, Melbourne, and others, capturing not just the artworks but the stories behind them through interviews with local artists.",
    goal: 40000,
    end_date: Date.today - 30.days,
    creator: users[3],
    status: "failed",
    image_url: "https://images.unsplash.com/photo-1481487196290-c152efe083f5?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Art"
  ),
  
  # Film & Video Project
  Project.create!(
    title: "Time Travel Documentary",
    description: "A documentary exploring the concept of time travel through interviews with experts and reenactments of historical events.\n\nThis documentary delves into the science and theory behind time travel, as well as its potential implications on our understanding of the universe.",
    goal: 20000,
    end_date: Date.today + 30.days,
    creator: users[0],
    status: "active",
    image_url: "https://images.unsplash.com/photo-1610890716171-6b1bb98ffd09?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Film & Video"
  )
]

puts "Creating rewards with varied fulfillment statuses..."
# ALIEN RPG Project Rewards - Active project, different statuses
Reward.create!(
  project: projects[0],
  title: "Digital Core Rulebook",
  description: "Get the complete ALIEN RPG Evolved Edition core rulebook in digital format (PDF). Includes all rules, setting information, and the new cinematic scenario.",
  amount: 25,
  estimated_delivery: Date.today + 3.months,
  status: Reward::STATUSES[:in_production],
  fulfillment_progress: 25
)

Reward.create!(
  project: projects[0],
  title: "Standard Edition",
  description: "Hardcover ALIEN RPG Evolved Edition core rulebook + PDF version + digital stretch goals.",
  amount: 60,
  estimated_delivery: Date.today + 5.months,
  status: Reward::STATUSES[:in_production],
  fulfillment_progress: 40
)

Reward.create!(
  project: projects[0],
  title: "Special Edition",
  description: "Limited Special Edition with exclusive cover art, ribbon bookmark, and poster map + PDF version + all digital stretch goals.",
  amount: 100,
  estimated_delivery: Date.today + 5.months,
  status: Reward::STATUSES[:in_transit],
  fulfillment_progress: 65
)

Reward.create!(
  project: projects[0],
  title: "Collector's Edition",
  description: "Deluxe Collector's Edition with alternative cover, embossed details, premium binding, slipcase, and exclusive art prints + PDF version + all digital and physical stretch goals.",
  amount: 300,
  estimated_delivery: Date.today + 7.months,
  status: Reward::STATUSES[:not_started],
  fulfillment_progress: 0
)

# Animation VERSUS Project Rewards - Active project, not started
Reward.create!(
  project: projects[1],
  title: "Digital Game",
  description: "Digital copy of Animation VERSUS for PC (Steam). Get ready to battle with your favorite stick figures!",
  amount: 20,
  estimated_delivery: projects[1].end_date + 12.months,
  status: Reward::STATUSES[:not_started],
  fulfillment_progress: 0
)

Reward.create!(
  project: projects[1],
  title: "Deluxe Digital Edition",
  description: "Digital copy of the game + digital artbook + soundtrack + exclusive character skin pack.",
  amount: 40,
  estimated_delivery: projects[1].end_date + 12.months,
  status: Reward::STATUSES[:not_started],
  fulfillment_progress: 0
)

Reward.create!(
  project: projects[1],
  title: "Physical Collector's Edition",
  description: "Physical collector's box with the game, artbook, soundtrack CD, exclusive figurine, and all digital content.",
  amount: 100,
  estimated_delivery: projects[1].end_date + 14.months,
  status: Reward::STATUSES[:not_started],
  fulfillment_progress: 0
)

# Misen Carbon Nonstick Pan Rewards - Active project, in production
Reward.create!(
  project: projects[2],
  title: "Early Bird - 8\" Pan",
  description: "One 8\" Misen Carbon Nonstick Pan at a special early bird price. Perfect for smaller meals and side dishes.",
  amount: 55,
  estimated_delivery: projects[2].end_date + 4.months,
  status: Reward::STATUSES[:in_production],
  fulfillment_progress: 25
)

Reward.create!(
  project: projects[2],
  title: "10\" Pan",
  description: "One 10\" Misen Carbon Nonstick Pan. Our most versatile size, perfect for everyday cooking.",
  amount: 75,
  estimated_delivery: projects[2].end_date + 4.months,
  status: Reward::STATUSES[:in_production],
  fulfillment_progress: 30
)

Reward.create!(
  project: projects[2],
  title: "Complete Set",
  description: "The complete set: 8\", 10\", and 12\" Misen Carbon Nonstick Pans. Everything you need for your kitchen.",
  amount: 175,
  estimated_delivery: projects[2].end_date + 4.months,
  status: Reward::STATUSES[:in_production],
  fulfillment_progress: 20
)

# The Wonderbox of Alice Rewards - Ended project in fulfillment
Reward.create!(
  project: projects[7],
  title: "Standard Wonderbox",
  description: "The complete Wonderbox of Alice puzzle experience with over 10 interconnected puzzles and collectible keepsakes.",
  amount: 65,
  estimated_delivery: Date.today + 1.month,
  status: Reward::STATUSES[:in_transit],
  fulfillment_progress: 65
)

Reward.create!(
  project: projects[7],
  title: "Deluxe Wonderbox",
  description: "Enhanced edition with premium components, additional puzzles, and expanded narrative content.",
  amount: 95,
  estimated_delivery: Date.today + 1.month,
  status: Reward::STATUSES[:shipping_soon],
  fulfillment_progress: 80
)

Reward.create!(
  project: projects[7],
  title: "Collector's Wonderbox",
  description: "Ultimate edition with exclusive hand-crafted wooden box, metal components, and signed art book.",
  amount: 165,
  estimated_delivery: Date.today + 2.months,
  status: Reward::STATUSES[:in_production],
  fulfillment_progress: 35
)

# EcoCharge Rewards - Completed project
Reward.create!(
  project: projects[8],
  title: "EcoCharge Basic",
  description: "Single device charging station with solar panel and built-in battery.",
  amount: 65,
  estimated_delivery: Date.today - 2.months,
  status: Reward::STATUSES[:completed],
  fulfillment_progress: 100
)

Reward.create!(
  project: projects[8],
  title: "EcoCharge Plus",
  description: "Multi-device charging station with expanded solar panel and higher capacity battery.",
  amount: 95,
  estimated_delivery: Date.today - 2.months,
  status: Reward::STATUSES[:completed],
  fulfillment_progress: 100
)

Reward.create!(
  project: projects[8],
  title: "EcoCharge Pro",
  description: "Premium charging station with maximum capacity solar panels, LED lighting, and weather resistance.",
  amount: 145,
  estimated_delivery: Date.today - 1.month,
  status: Reward::STATUSES[:completed],
  fulfillment_progress: 100
)

# Add rewards for other projects with varied statuses
[3, 4, 5, 6, 9, 10].each do |project_index|
  project = projects[project_index]
  
  # Determine the status and progress for the rewards
  status = nil
  progress = 0
  
  case project_index
  when 3 # QUBE project
    status = Reward::STATUSES[:in_production]
    progress = 30
  when 4 # GAMEBAG project
    status = Reward::STATUSES[:not_started]
    progress = 0
  when 5 # Goliath Chronicles
    status = Reward::STATUSES[:not_started]
    progress = 0
  when 6 # Blood Over Bright Haven
    status = Reward::STATUSES[:in_production]
    progress = 35
  when 9 # Failed project
    status = nil
    progress = 0
  when 10 # Time Travel Documentary
    status = Reward::STATUSES[:not_started]
    progress = 0
  end
  
  # Create the rewards
  Reward.create!(
    project: project,
    title: "Early Bird Special",
    description: "Get in early and save! This reward tier offers all the core benefits at a discounted price.",
    amount: [25, 35, 45, 50].sample,
    estimated_delivery: project.end_date + 3.months,
    status: status,
    fulfillment_progress: progress
  )
  
  # Standard reward - varied status
  if project_index == 3 # QUBE project
    status = Reward::STATUSES[:in_production]
    progress = 25
  elsif project_index == 4 # GAMEBAG project
    status = Reward::STATUSES[:not_started]
    progress = 0
  elsif project_index == 6 # Blood Over Bright Haven
    status = Reward::STATUSES[:in_transit]
    progress = 55
  end
  
  Reward.create!(
    project: project,
    title: "Standard Backer",
    description: "The standard package with all core features and benefits.",
    amount: [50, 75, 99, 120].sample,
    estimated_delivery: project.end_date + 3.months,
    status: status,
    fulfillment_progress: progress
  )
  
  # Deluxe reward - varied status
  if project_index == 3 # QUBE project
    status = Reward::STATUSES[:not_started]
    progress = 0
  elsif project_index == 6 # Blood Over Bright Haven
    status = Reward::STATUSES[:shipping_soon]
    progress = 75
  end
  
  Reward.create!(
    project: project,
    title: "Deluxe Edition",
    description: "Everything in the Standard package plus exclusive bonus content and premium materials.",
    amount: [150, 199, 249, 299].sample,
    estimated_delivery: project.end_date + 4.months,
    status: status,
    fulfillment_progress: progress
  )
  
  # Premium reward for some projects - varied status
  if rand < 0.7
    if project_index == 3 # QUBE project
      status = Reward::STATUSES[:not_started]
      progress = 0
    elsif project_index == 6 # Blood Over Bright Haven
      status = Reward::STATUSES[:shipping]
      progress = 90
    end
    
    Reward.create!(
      project: project,
      title: "Premium Collector's Edition",
      description: "The ultimate experience with all exclusive content, behind-the-scenes access, and limited edition items.",
      amount: [350, 499, 799, 999].sample,
      estimated_delivery: project.end_date + 5.months,
      status: status,
      fulfillment_progress: progress
    )
  end
end

puts "Creating pledges..."
# Create realistic pledges for each project
projects.each do |project|
  # Determine how many backers based on project status
  backer_count = project.status == "completed" ? rand(20..50) : rand(5..25)
  
  # Get rewards for this project
  rewards = project.rewards.to_a
  
  backer_count.times do
    # Randomly select a user who isn't the creator
    backer = users.reject { |u| u == project.creator }.sample
    
    # Usually select a reward, sometimes no reward
    reward = rand < 0.85 ? rewards.sample : nil
    
    # Create pledge with realistic amount
    Pledge.create!(
      backer: backer,
      project: project,
      reward: reward,
      amount: reward ? reward.amount + [0, 5, 10, 20].sample : [15, 25, 50, 100].sample,
      status: project.status == "completed" ? "completed" : ["pending", "completed"].sample
    )
  end
end

puts "Creating reward items..."
# Get the ALIEN RPG project
alien_project = Project.find_by(title: "ALIEN RPG - Evolved Edition")
if alien_project
  # Get the rewards for the project
  pdf_reward = alien_project.rewards.find_by(title: "Digital Core Rulebook")
  if pdf_reward
    [
      {name: "Core Rulebook PDF", description: "Digital version of the core rulebook", quantity_per_reward: 1, produced_count: 250, shipped_count: 250},
      {name: "Character Sheets", description: "Printable character sheets", quantity_per_reward: 1, produced_count: 250, shipped_count: 250}
    ].each do |item_attrs|
      pdf_reward.reward_items.create!(item_attrs)
    end
  end
  
  hardcover_reward = alien_project.rewards.find_by(title: "Standard Edition")
  if hardcover_reward
    [
      {name: "Core Rulebook - Hardcover", description: "Physical copy of the core rulebook", quantity_per_reward: 1, produced_count: 70, shipped_count: 35},
      {name: "Core Rulebook - PDF", description: "Digital version of the core rulebook", quantity_per_reward: 1, produced_count: 120, shipped_count: 120},
      {name: "Custom Dice Set", description: "Set of custom ALIEN RPG dice", quantity_per_reward: 1, produced_count: 50, shipped_count: 25},
      {name: "GM Screen", description: "Game Master screen with helpful tables", quantity_per_reward: 1, produced_count: 40, shipped_count: 15}
    ].each do |item_attrs|
      hardcover_reward.reward_items.create!(item_attrs)
    end
  end
  
  collector_reward = alien_project.rewards.find_by(title: "Collector's Edition")
  if collector_reward
    [
      {name: "Collector's Edition Rulebook", description: "Limited edition rulebook with exclusive cover", quantity_per_reward: 1, produced_count: 15, shipped_count: 0},
      {name: "Concept Art Book", description: "Behind-the-scenes concept artwork", quantity_per_reward: 1, produced_count: 10, shipped_count: 0},
      {name: "Exclusive Miniatures Set", description: "Set of 5 limited miniatures", quantity_per_reward: 1, produced_count: 5, shipped_count: 0},
      {name: "Poster Map", description: "High-quality poster map of known space", quantity_per_reward: 1, produced_count: 20, shipped_count: 0},
      {name: "Metal Dice Set", description: "Premium metal dice with case", quantity_per_reward: 1, produced_count: 0, shipped_count: 0}
    ].each do |item_attrs|
      collector_reward.reward_items.create!(item_attrs)
    end
  end
end

# Add items for the Time Travel project
time_travel_project = Project.find_by(title: "Time Travel Documentary")
if time_travel_project
  time_travel_project.rewards.each do |reward|
    [
      {name: "Documentary - Digital Download", description: "Digital download of the documentary", quantity_per_reward: 1, produced_count: 200, shipped_count: 180},
      {name: "Behind-the-scenes Footage", description: "Extra footage and interviews", quantity_per_reward: 1, produced_count: 150, shipped_count: 120}
    ].each do |item_attrs|
      reward.reward_items.create!(item_attrs)
    end
  end
end

# Add items for the game project
game_project = Project.find_by(title: "Animation VERSUS - Fighting Game")
if game_project
  early_access_reward = game_project.rewards.first
  if early_access_reward
    [
      {name: "Game Download Key", description: "Digital key to download the game", quantity_per_reward: 1, produced_count: 500, shipped_count: 500},
      {name: "Beta Access Pass", description: "Early access to game beta", quantity_per_reward: 1, produced_count: 500, shipped_count: 500},
      {name: "Digital Art Book", description: "Downloadable art book", quantity_per_reward: 1, produced_count: 450, shipped_count: 450}
    ].each do |item_attrs|
      early_access_reward.reward_items.create!(item_attrs)
    end
  end
  
  deluxe_reward = game_project.rewards.last
  if deluxe_reward
    [
      {name: "Game Download Key", description: "Digital key to download the game", quantity_per_reward: 1, produced_count: 200, shipped_count: 200},
      {name: "Physical Collector's Box", description: "Special edition box with game merchandise", quantity_per_reward: 1, produced_count: 50, shipped_count: 0},
      {name: "Character Figurine", description: "Collectible game character figurine", quantity_per_reward: 1, produced_count: 20, shipped_count: 0},
      {name: "Soundtrack CD", description: "Original game soundtrack on CD", quantity_per_reward: 1, produced_count: 100, shipped_count: 0}
    ].each do |item_attrs|
      deluxe_reward.reward_items.create!(item_attrs)
    end
  end
end

puts "Seed data created successfully!"
puts "Created #{User.count} users"
puts "Created #{Project.count} projects"
puts "Created #{Reward.count} rewards"
puts "Created #{Pledge.count} pledges"
puts "Created #{RewardItem.count} reward items"

# Set up fulfillment waves with proper varied statuses and visible tracking data
puts "\n=== Setting up enhanced fulfillment tracking data ==="

# 1. Ensure admin owns projects
admin = User.find_by(email: "admin@example.com")
if admin
  puts "Associating projects with admin..."
  Project.all.each do |project|
    project.update_columns(creator_id: admin.id)
    puts "  Associated '#{project.title}' with admin"
  end
end

# 2. Focus on two main projects for the demo
alien_project = Project.find_by(title: "ALIEN RPG - Evolved Edition")
game_project = Project.find_by(title: "Animation VERSUS - Fighting Game")

if alien_project && game_project
  puts "Setting up showcase projects..."
  
  # 3. Create fulfillment waves with varied statuses
  puts "Creating fulfillment waves with varied statuses..."
  
  # ALIEN RPG project waves
  if alien_project.fulfillment_waves.count < 4
    # Remove any existing waves to avoid duplicates
    alien_project.fulfillment_waves.destroy_all
    
    # A. Completed wave (Digital Products)
    digital_wave = FulfillmentWave.create!(
      project: alien_project,
      name: "Digital Products (Completed)",
      status: "completed",
      target_ship_date: Date.today - 30.days,
      description: "All digital products including PDFs and digital stretch goals."
    )
    puts "  Created completed wave: #{digital_wave.name}"
    
    # B. Shipping wave (Early Backers)
    early_wave = FulfillmentWave.create!(
      project: alien_project,
      name: "Early Backer Rewards (Shipping)",
      status: "shipping",
      target_ship_date: Date.today - 3.days,
      description: "Priority shipment for early backers of the Digital + Physical bundle."
    )
    puts "  Created shipping wave: #{early_wave.name}"
    
    # C. In Progress wave (Core Products)
    core_wave = FulfillmentWave.create!(
      project: alien_project,
      name: "Core Rulebooks (In Progress)",
      status: "in_progress",
      target_ship_date: Date.today + 15.days,
      description: "Physical rulebooks, dice sets, and GM screens for all backers."
    )
    puts "  Created in-progress wave: #{core_wave.name}"
    
    # D. Planned wave (Stretch Goals)
    stretch_wave = FulfillmentWave.create!(
      project: alien_project,
      name: "Stretch Goal Items (Planned)",
      status: "planned",
      target_ship_date: Date.today + 60.days,
      description: "Exclusive stretch goal items unlocked during campaign."
    )
    puts "  Created planned wave: #{stretch_wave.name}"
    
    # Get items for each wave (digital, physical, collector)
    digital_items = RewardItem.joins(:reward)
                           .where(rewards: { project_id: alien_project.id })
                           .where("reward_items.name LIKE ?", "%PDF%")
                           .or(RewardItem.joins(:reward)
                                       .where(rewards: { project_id: alien_project.id })
                                       .where("reward_items.name LIKE ?", "%Digital%"))
                           .limit(3)
    
    physical_items = RewardItem.joins(:reward)
                            .where(rewards: { project_id: alien_project.id })
                            .where("reward_items.name LIKE ?", "%Rulebook%")
                            .or(RewardItem.joins(:reward)
                                        .where(rewards: { project_id: alien_project.id })
                                        .where("reward_items.name LIKE ?", "%Dice%"))
                            .limit(3)
    
    collector_items = RewardItem.joins(:reward)
                             .where(rewards: { project_id: alien_project.id })
                             .where("reward_items.name LIKE ?", "%Collector%")
                             .or(RewardItem.joins(:reward)
                                         .where(rewards: { project_id: alien_project.id })
                                         .where("reward_items.name LIKE ?", "%Art%"))
                             .limit(3)
    
    # If any item group is empty, just get some items
    if digital_items.empty? || physical_items.empty? || collector_items.empty?
      all_items = RewardItem.joins(:reward).where(rewards: { project_id: alien_project.id }).to_a
      
      if all_items.present?
        digital_items = all_items.first(3) if digital_items.empty?
        physical_items = all_items[3..5] if physical_items.empty?
        collector_items = all_items[6..8] if collector_items.empty?
      end
    end
    
    # Add items to waves with appropriate progress
    if digital_items.present?
      digital_items.each do |item|
        # For completed wave - 100% complete
        wave_item = WaveItem.create!(
          fulfillment_wave: digital_wave,
          reward_item: item,
          quantity: 100
        )
        
        # First update total_needed to ensure we can set produced_count properly
        item.update!(
          quantity_per_reward: 1,
          total_needed: 100  # Set total_needed explicitly to match produced_count
        )
        
        # Then update production counts
        item.update!(
          produced_count: 100,
          shipped_count: 100
        )
      end
    end
    
    if physical_items.present?
      # Split physical items between shipping and in-progress waves
      physical_items.each_with_index do |item, index|
        if index == 0 
          # For shipping wave - 100% produced, 70% shipped
          wave_item = WaveItem.create!(
            fulfillment_wave: early_wave,
            reward_item: item,
            quantity: 100
          )
          
          # First update total_needed to ensure we can set produced_count properly
          item.update!(
            quantity_per_reward: 1,
            total_needed: 100  # Set total_needed explicitly to match produced_count
          )
          
          # Then update production counts
          item.update!(
            produced_count: 100,
            shipped_count: 70
          )
        else
          # For in-progress wave - 50% produced, 0% shipped
          wave_item = WaveItem.create!(
            fulfillment_wave: core_wave,
            reward_item: item,
            quantity: 100
          )
          
          # First update total_needed to ensure we can set produced_count properly
          item.update!(
            quantity_per_reward: 1,
            total_needed: 100  # Set total_needed explicitly to match produced_count
          )
          
          # Then update production counts
          item.update!(
            produced_count: 50,
            shipped_count: 0
          )
        end
      end
    end
    
    if collector_items.present?
      collector_items.each do |item|
        # For planned wave - 10% produced, 0% shipped
        wave_item = WaveItem.create!(
          fulfillment_wave: stretch_wave,
          reward_item: item,
          quantity: 100
        )
        
        # First update total_needed to ensure we can set produced_count properly
        item.update!(
          quantity_per_reward: 1,
          total_needed: 100  # Set total_needed explicitly to match produced_count
        )
        
        # Then update production counts
        item.update!(
          produced_count: 10,
          shipped_count: 0
        )
      end
    end
  end
end

# Game project waves
if game_project.fulfillment_waves.count < 3
  # Remove any existing waves to avoid duplicates
  game_project.fulfillment_waves.destroy_all
  
  # A. Completed wave (Digital Keys)
  keys_wave = FulfillmentWave.create!(
    project: game_project,
    name: "Digital Keys (Completed)",
    status: "completed",
    target_ship_date: Date.today - 20.days,
    description: "Distribution of all game download keys."
  )
  puts "  Created completed wave: #{keys_wave.name}"
  
  # B. In Progress wave (Digital Assets)
  assets_wave = FulfillmentWave.create!(
    project: game_project,
    name: "Digital Assets (In Progress)",
    status: "in_progress",
    target_ship_date: Date.today + 5.days,
    description: "Digital art books and soundtrack distribution."
  )
  puts "  Created in-progress wave: #{assets_wave.name}"
  
  # C. Planned wave (Physical Merch)
  merch_wave = FulfillmentWave.create!(
    project: game_project,
    name: "Physical Merchandise (Planned)",
    status: "planned",
    target_ship_date: Date.today + 45.days,
    description: "All physical items including collector's boxes, figurines, and CDs."
  )
  puts "  Created planned wave: #{merch_wave.name}"
  
  # Get items for each wave
  digital_keys = RewardItem.joins(:reward)
                        .where(rewards: { project_id: game_project.id })
                        .where("reward_items.name LIKE ?", "%Key%")
                        .limit(2)
  
  digital_assets = RewardItem.joins(:reward)
                          .where(rewards: { project_id: game_project.id })
                          .where("reward_items.name LIKE ?", "%Art%")
                          .or(RewardItem.joins(:reward)
                                      .where(rewards: { project_id: game_project.id })
                                      .where("reward_items.name LIKE ?", "%Soundtrack%"))
                          .limit(2)
  
  physical_merch = RewardItem.joins(:reward)
                         .where(rewards: { project_id: game_project.id })
                         .where("reward_items.name LIKE ?", "%Box%")
                         .or(RewardItem.joins(:reward)
                                     .where(rewards: { project_id: game_project.id })
                                     .where("reward_items.name LIKE ?", "%Figurine%"))
                         .limit(2)
  
  # If any item group is empty, get other items
  if digital_keys.empty? || digital_assets.empty? || physical_merch.empty?
    all_items = RewardItem.joins(:reward).where(rewards: { project_id: game_project.id }).to_a
    
    if all_items.present?
      digital_keys = all_items.first(2) if digital_keys.empty?
      digital_assets = all_items[2..3] if digital_assets.empty?
      physical_merch = all_items[4..5] if physical_merch.empty?
    end
  end
  
  # Add items to waves with appropriate progress
  if digital_keys.present?
    digital_keys.each do |item|
      # For completed wave - 100% complete
      wave_item = WaveItem.create!(
        fulfillment_wave: keys_wave,
        reward_item: item,
        quantity: 100
      )
      
      # First update total_needed to ensure we can set produced_count properly
      item.update!(
        quantity_per_reward: 1,
        total_needed: 100  # Set total_needed explicitly to match produced_count
      )
      
      # Then update production counts
      item.update!(
        produced_count: 100,
        shipped_count: 100
      )
    end
  end
  
  if digital_assets.present?
    digital_assets.each do |item|
      # For in-progress wave - 70% produced, 30% shipped
      wave_item = WaveItem.create!(
        fulfillment_wave: assets_wave,
        reward_item: item,
        quantity: 100
      )
      
      # First update total_needed to ensure we can set produced_count properly
      item.update!(
        quantity_per_reward: 1,
        total_needed: 100  # Set total_needed explicitly to match what we need
      )
      
      # Then update production counts
      item.update!(
        produced_count: 70,
        shipped_count: 30
      )
    end
  end
  
  if physical_merch.present?
    physical_merch.each do |item|
      # For planned wave - 5% produced, 0% shipped
      wave_item = WaveItem.create!(
        fulfillment_wave: merch_wave,
        reward_item: item,
        quantity: 100
      )
      
      # First update total_needed to ensure we can set produced_count properly
      item.update!(
        quantity_per_reward: 1,
        total_needed: 100  # Set total_needed explicitly to match what we need
      )
      
      # Then update production counts
      item.update!(
        produced_count: 5,
        shipped_count: 0
      )
    end
  end
end
  
# Update rewards' fulfillment progress based on items
puts "Updating reward fulfillment progress based on items..."
[alien_project, game_project].each do |project|
  project.rewards.each do |reward|
    if reward.reward_items.any?
      total_quantity = reward.reward_items.sum { |item| item.quantity_per_reward || 1 }
      total_produced = reward.reward_items.sum { |item| item.produced_count || 0 }
      
      progress = [(total_produced.to_f / total_quantity * 100).round, 100].min
      reward.update_columns(fulfillment_progress: progress)
    end
  end
end

puts "Fulfillment tracking data setup complete!"

puts ""
puts "You can log in with:"
puts "Email: admin@example.com"
puts "Password: password"
puts ""
puts "Or any of the sample users:"
puts "Email: sarah@example.com, michael@example.com, etc."
puts "Password: password"
