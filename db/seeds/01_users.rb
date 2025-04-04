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

puts "Created #{User.count} users"
