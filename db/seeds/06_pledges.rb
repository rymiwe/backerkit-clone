puts "Creating pledges..."

# Get users
users = User.where(roles: "backer").to_a
admin = User.find_by(email: "admin@example.com")

# Get rewards
rewards = Reward.all.to_a

# For each user, create 2-4 pledges to random rewards
users.each do |user|
  # Skip admin (we'll handle admin separately)
  next if user == admin
  
  # Determine how many pledges for this user (2-4)
  pledge_count = rand(2..4)
  
  # Get random rewards
  user_rewards = rewards.sample(pledge_count)
  
  user_rewards.each do |reward|
    # Create pledge
    Pledge.create!(
      user: user,
      reward: reward,
      amount: reward.amount + rand(0..50), # Random additional amount as a "tip"
      status: "successful"
    )
  end
end

# Create pledges for admin as well
[1, 4, 7].each do |reward_index|
  if rewards.length > reward_index
    Pledge.create!(
      user: admin,
      reward: rewards[reward_index],
      amount: rewards[reward_index].amount,
      status: "successful"
    )
  end
end

puts "Created #{Pledge.count} pledges"
