# Seeds for fulfillment waves
puts "Creating fulfillment waves..."

# Create fulfillment waves for ALIEN RPG Project (active project with items in different states)
alien_project = Project.find_by(title: "ALIEN RPG - Evolved Edition")
if alien_project
  # Wave 1: In Progress - Digital Rewards with high progress
  digital_wave = FulfillmentWave.create!(
    project: alien_project,
    name: "Digital Products Wave",
    target_ship_date: Date.today - 5.days,
    status: "in_progress",
    description: "All digital products including PDFs and digital stretch goals."
  )
  
  # Find digital items to include in this wave
  digital_items = RewardItem.joins(:reward)
                            .where(rewards: { project_id: alien_project.id })
                            .where("reward_items.name LIKE ?", "%PDF%")
                            .or(RewardItem.joins(:reward)
                                        .where(rewards: { project_id: alien_project.id })
                                        .where("reward_items.name LIKE ?", "%Digital%"))
                            .limit(4)
  
  # Add items to the wave with varied progress
  digital_items.each_with_index do |item, index|
    wave_item = WaveItem.create!(
      fulfillment_wave: digital_wave,
      reward_item: item,
      quantity: [50, 75, 100, 125][index % 4]
    )
    
    # First ensure total_needed is set properly
    item.update!(
      total_needed: wave_item.quantity
    )
    
    # Create more progress for this wave (75-95%)
    progress_percentage = 75 + rand(0..20)
    
    # Update produced and shipped counts for visible progress
    item.update!(
      produced_count: (wave_item.quantity * progress_percentage / 100.0).round,
      shipped_count: (wave_item.quantity * (progress_percentage - 15) / 100.0).round
    )
  end
  
  # Wave 2: Planned - Physical Core Products (low progress)
  core_wave = FulfillmentWave.create!(
    project: alien_project,
    name: "Core Rulebooks Wave",
    target_ship_date: Date.today + 20.days,
    status: "planned",
    description: "Physical rulebooks, dice sets, and GM screens for all backers."
  )
  
  # Find core physical items
  core_items = RewardItem.joins(:reward)
                        .where(rewards: { project_id: alien_project.id })
                        .where("reward_items.name LIKE ?", "%Rulebook%")
                        .or(RewardItem.joins(:reward)
                                    .where(rewards: { project_id: alien_project.id })
                                    .where("reward_items.name LIKE ?", "%Dice%"))
                        .or(RewardItem.joins(:reward)
                                    .where(rewards: { project_id: alien_project.id })
                                    .where("reward_items.name LIKE ?", "%Screen%"))
                        .limit(3)
  
  # Add items to the wave with lower progress
  core_items.each_with_index do |item, index|
    wave_item = WaveItem.create!(
      fulfillment_wave: core_wave,
      reward_item: item,
      quantity: [200, 150, 175][index % 3]
    )
    
    # First ensure total_needed is set properly
    item.update!(
      total_needed: wave_item.quantity
    )
    
    # Create less progress for this wave (10-30%)
    progress_percentage = 10 + rand(0..20)
    
    # Update produced counts for visible progress, but no shipping yet
    item.update!(
      produced_count: (wave_item.quantity * progress_percentage / 100.0).round,
      shipped_count: 0
    )
  end
  
  # Wave 3: Shipping - Early Bird Shipments (high progress, shipping status)
  early_wave = FulfillmentWave.create!(
    project: alien_project,
    name: "Early Bird Rewards Wave",
    target_ship_date: Date.today - 2.days,
    status: "shipping",
    description: "Priority shipment for early backers of the Digital + Physical bundle."
  )
  
  # Just use a subset of the core items for this wave to simulate early backers
  early_items = core_items.limit(2)
  
  # Add items to the wave with high production but mid shipping
  early_items.each_with_index do |item, index|
    wave_item = WaveItem.create!(
      fulfillment_wave: early_wave,
      reward_item: item, 
      quantity: [40, 30][index % 2]
    )
    
    # First ensure total_needed is set properly
    item.update!(
      total_needed: wave_item.quantity
    )
    
    # High production but partial shipping (80-100% produced, 40-60% shipped)
    produced_percentage = 80 + rand(0..20)
    shipped_percentage = 40 + rand(0..20)
    
    # Update the item's counters
    item.update!(
      produced_count: (wave_item.quantity * produced_percentage / 100.0).round,
      shipped_count: (wave_item.quantity * shipped_percentage / 100.0).round
    )
  end
  
  # Wave 4: Completed - Limited Edition Extras
  completed_wave = FulfillmentWave.create!(
    project: alien_project,
    name: "Limited Edition Extras",
    target_ship_date: Date.today - 15.days,
    status: "completed", 
    description: "Special limited edition items for high-tier backers."
  )
  
  # Use remaining items or create new ones
  limited_items = RewardItem.joins(:reward)
                           .where(rewards: { project_id: alien_project.id })
                           .where("reward_items.name LIKE ?", "%Poster%")
                           .or(RewardItem.joins(:reward)
                                        .where(rewards: { project_id: alien_project.id })
                                        .where("reward_items.name LIKE ?", "%Art%"))
                           .limit(2)
  
  # Add items to the wave with 100% completion
  limited_items.each do |item|
    wave_item = WaveItem.create!(
      fulfillment_wave: completed_wave,
      reward_item: item,
      quantity: 25
    )
    
    # First ensure total_needed is set properly
    item.update!(
      total_needed: wave_item.quantity
    )
    
    # 100% completed
    item.update!(
      produced_count: wave_item.quantity,
      shipped_count: wave_item.quantity
    )
  end
end

# Create Fulfillment Waves for Animation VERSUS Game (active project with planned waves)
game_project = Project.find_by(title: "Animation VERSUS - Fighting Game")
if game_project
  # Wave 1: Completed - Digital Game Keys 
  digital_wave = FulfillmentWave.create!(
    project: game_project,
    name: "Digital Keys Wave",
    target_ship_date: Date.today - 15.days,
    status: "completed",
    description: "Distribution of game keys and beta access passes."
  )
  
  # Find any digital items
  game_items = RewardItem.joins(:reward)
                        .where(rewards: { project_id: game_project.id })
                        .where("reward_items.name LIKE ?", "%Key%")
                        .or(RewardItem.joins(:reward)
                                     .where(rewards: { project_id: game_project.id })
                                     .where("reward_items.name LIKE ?", "%Beta%"))
                        .limit(2)
  
  # If no specific items found, use any from this project
  if game_items.empty?
    game_items = RewardItem.joins(:reward).where(rewards: { project_id: game_project.id }).limit(2)
  end
  
  # Add items to the wave with 100% completion
  game_items.each do |item|
    wave_item = WaveItem.create!(
      fulfillment_wave: digital_wave,
      reward_item: item,
      quantity: 300
    )
    
    # First ensure total_needed is set properly
    item.update!(
      total_needed: wave_item.quantity
    )
    
    # 100% completed
    item.update!(
      produced_count: wave_item.quantity,
      shipped_count: wave_item.quantity
    )
  end
  
  # Wave 2: In Progress - Digital Art Books
  art_wave = FulfillmentWave.create!(
    project: game_project,
    name: "Digital Art Assets Wave",
    target_ship_date: Date.today,
    status: "in_progress",
    description: "Digital art books and soundtrack distribution."
  )
  
  # Find art book items or use remaining items
  art_items = RewardItem.joins(:reward)
                       .where(rewards: { project_id: game_project.id })
                       .where("reward_items.name LIKE ?", "%Art%")
                       .or(RewardItem.joins(:reward)
                                    .where(rewards: { project_id: game_project.id })
                                    .where("reward_items.name LIKE ?", "%Soundtrack%"))
                       .limit(2)
  
  # If no art items found, use any remaining items
  if art_items.empty?
    used_ids = game_items.pluck(:id)
    art_items = RewardItem.joins(:reward)
                         .where(rewards: { project_id: game_project.id })
                         .where.not(id: used_ids)
                         .limit(2)
  end
  
  # Add items to the wave with partial progress
  art_items.each_with_index do |item, index|
    wave_item = WaveItem.create!(
      fulfillment_wave: art_wave,
      reward_item: item,
      quantity: [200, 250][index % 2]
    )
    
    # First ensure total_needed is set properly
    item.update!(
      total_needed: wave_item.quantity
    )
    
    # 60-80% progress
    progress_percentage = 60 + rand(0..20)
    
    # Update counts for visible progress
    item.update!(
      produced_count: (wave_item.quantity * progress_percentage / 100.0).round,
      shipped_count: (wave_item.quantity * (progress_percentage - 20) / 100.0).round
    )
  end
  
  # Wave 3: Planned - Physical Items
  physical_wave = FulfillmentWave.create!(
    project: game_project,
    name: "Physical Merchandise Wave",
    target_ship_date: Date.today + 60.days,
    status: "planned",
    description: "All physical items including collector's boxes, figurines, and CDs."
  )
  
  # Find physical items or use any items left
  all_used_ids = game_items.pluck(:id) + art_items.pluck(:id)
  physical_items = RewardItem.joins(:reward)
                            .where(rewards: { project_id: game_project.id })
                            .where.not(id: all_used_ids)
                            .limit(3)
  
  # Add items to the wave with minimal progress
  physical_items.each do |item|
    wave_item = WaveItem.create!(
      fulfillment_wave: physical_wave,
      reward_item: item,
      quantity: rand(100..150)
    )
    
    # First ensure total_needed is set properly
    item.update!(
      total_needed: wave_item.quantity
    )
    
    # 5-15% progress
    progress_percentage = 5 + rand(0..10)
    
    # Update produced counts only
    item.update!(
      produced_count: (wave_item.quantity * progress_percentage / 100.0).round,
      shipped_count: 0
    )
  end
end

# Create a wave for a completed project to show historical data
completed_project = Project.where(status: "successful").first
if completed_project
  historical_wave = FulfillmentWave.create!(
    project: completed_project,
    name: "Full Release Wave",
    target_ship_date: Date.today - 60.days,
    status: "completed",
    description: "Complete fulfillment of all project rewards."
  )
  
  # Find some items from this project
  items = RewardItem.joins(:reward).where(rewards: { project_id: completed_project.id }).limit(4)
  
  # Add items to the wave with 100% completion
  items.each do |item|
    quantity = rand(150..250)
    WaveItem.create!(
      fulfillment_wave: historical_wave,
      reward_item: item,
      quantity: quantity
    )
    
    # First ensure total_needed is set properly
    item.update!(
      total_needed: quantity
    )
    
    # 100% completed
    item.update!(
      produced_count: quantity,
      shipped_count: quantity
    )
  end
end

puts "Created #{FulfillmentWave.count} fulfillment waves"
puts "Created #{WaveItem.count} wave items"
