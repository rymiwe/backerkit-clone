puts "Updating production and shipping data to demonstrate fulfillment progress..."

# Get the projects we want to enhance with varied fulfillment data
alien_project = Project.find_by(title: "ALIEN RPG - Evolved Edition")
game_project = Project.find_by(title: "Animation VERSUS - Fighting Game")

if alien_project
  puts "Enhancing ALIEN RPG project with varied progress..."
  
  # Find reward items from this project
  reward_items = RewardItem.joins(:reward)
                         .where(rewards: { project_id: alien_project.id })
  
  # Update item production counts to simulate progress
  reward_items.each_with_index do |item, index|
    # Calculate a produced percentage between 10-90% based on item index
    produced_percentage = 10 + ((index * 17) % 81) # Will give values between 10-90% 
    shipped_percentage = [produced_percentage - 20, 0].max # Shipped count is less than produced
    
    # Calculate the expected total needed based on quantity_per_reward
    total_needed = [(item.quantity_per_reward || 1) * 100, 1].max.round
    
    # First ensure total_needed is set properly - make it larger than what we'll produce
    item.update!(
      total_needed: total_needed
    )
    
    # Update the item with varied production data
    item.update!(
      produced_count: [(item.quantity_per_reward || 1) * produced_percentage / 100.0, 1].max.round,
      shipped_count: [(item.quantity_per_reward || 1) * shipped_percentage / 100.0, 0].max.round
    )
    
    puts "  - Updated #{item.name} with #{produced_percentage}% produced, #{shipped_percentage}% shipped"
  end
end

# Do the same for the game project
if game_project
  puts "Enhancing Animation VERSUS project with varied progress..."
  
  # Find reward items from this project
  game_items = RewardItem.joins(:reward)
                        .where(rewards: { project_id: game_project.id })
  
  # Update item production counts to simulate progress
  game_items.each_with_index do |item, index|
    # Calculate different production percentages
    produced_percentage = 15 + ((index * 23) % 76) # Different pattern from above (15-90%)
    shipped_percentage = [produced_percentage - 30, 0].max
    
    # Calculate the expected total needed based on quantity_per_reward
    total_needed = [(item.quantity_per_reward || 1) * 100, 1].max.round
    
    # First ensure total_needed is set properly - make it larger than what we'll produce
    item.update!(
      total_needed: total_needed
    )
    
    # Update the item with varied shipping data
    item.update!(
      produced_count: [(item.quantity_per_reward || 1) * produced_percentage / 100.0, 1].max.round,
      shipped_count: [(item.quantity_per_reward || 1) * shipped_percentage / 100.0, 0].max.round
    )
    
    puts "  - Updated #{item.name} with #{produced_percentage}% produced, #{shipped_percentage}% shipped"
  end
end

puts "Production and shipping data updated to demonstrate varied fulfillment progress"
