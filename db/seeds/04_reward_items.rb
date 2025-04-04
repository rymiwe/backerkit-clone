puts "Creating reward items..."

# Find projects and rewards
alien_project = Project.find_by(title: "ALIEN RPG - Evolved Edition")
game_project = Project.find_by(title: "Animation VERSUS - Fighting Game")
time_travel_project = Project.find_by(title: "Time Travel Documentary")
pan_project = Project.find_by(title: "The Misen Carbon Nonstick Pan")

# Add items for the ALIEN RPG project
if alien_project
  # Find the specific rewards
  digital_reward = alien_project.rewards.find_by(title: "Digital Core Rulebook")
  if digital_reward
    [
      {name: "Core Rulebook - PDF", description: "Digital version of the core rulebook", quantity_per_reward: 1, produced_count: 1200, shipped_count: 1200},
      {name: "Digital GM Resources", description: "Additional resources for Game Masters", quantity_per_reward: 1, produced_count: 1000, shipped_count: 1000},
      {name: "Digital Character Sheets", description: "Fillable character sheets", quantity_per_reward: 1, produced_count: 1200, shipped_count: 1200}
    ].each do |item_attrs|
      digital_reward.reward_items.create!(item_attrs)
    end
  end
  
  hardcover_reward = alien_project.rewards.find_by(title: "Hardcover Core Rulebook")
  if hardcover_reward
    [
      {name: "Core Rulebook - Hardcover", description: "Physical hardcover rulebook", quantity_per_reward: 1, produced_count: 500, shipped_count: 325},
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
if game_project
  early_access_reward = game_project.rewards.find_by(title: "Early Access Digital Edition")
  if early_access_reward
    [
      {name: "Game Download Key", description: "Digital key to download the game", quantity_per_reward: 1, produced_count: 500, shipped_count: 500},
      {name: "Beta Access Pass", description: "Early access to game beta", quantity_per_reward: 1, produced_count: 500, shipped_count: 500},
      {name: "Digital Art Book", description: "Downloadable art book", quantity_per_reward: 1, produced_count: 450, shipped_count: 450}
    ].each do |item_attrs|
      early_access_reward.reward_items.create!(item_attrs)
    end
  end
  
  deluxe_reward = game_project.rewards.find_by(title: "Collector's Physical Edition")
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

# Add items for the Misen Pan project
if pan_project
  pan_project.rewards.each do |reward|
    size = case reward.title
           when /8\"/ then "8-inch"
           when /10\"/ then "10-inch"
           when /Complete/ then "Set of pans"
           else "Standard pan"
           end
    
    [
      {name: "#{size} Carbon Nonstick Pan", description: "The #{size.downcase} Misen carbon nonstick pan", quantity_per_reward: 1, produced_count: 75, shipped_count: 0},
      {name: "Care Instructions", description: "Detailed care and maintenance guide", quantity_per_reward: 1, produced_count: 100, shipped_count: 0}
    ].each do |item_attrs|
      reward.reward_items.create!(item_attrs)
    end
    
    # Add extra items for the complete set
    if reward.title == "Complete Set"
      [
        {name: "Pan Protectors", description: "Felt protectors to prevent scratching when stacked", quantity_per_reward: 3, produced_count: 30, shipped_count: 0},
        {name: "Wooden Utensil Set", description: "Set of wooden spatulas and utensils", quantity_per_reward: 1, produced_count: 15, shipped_count: 0}
      ].each do |item_attrs|
        reward.reward_items.create!(item_attrs)
      end
    end
  end
end

puts "Created #{RewardItem.count} reward items"
