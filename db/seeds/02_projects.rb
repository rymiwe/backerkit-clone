puts "Creating projects..."
# Project categories based on actual BackerKit categories
categories = ["Games", "Technology", "Design", "Comics", "Food", "Fashion", "Publishing", "Art", "Music", "Film & Video"]

# Get users for creating projects
admin = User.find_by(email: "admin@example.com")
users = User.where.not(email: "admin@example.com").limit(10).to_a

# Create realistic projects based on actual BackerKit projects
projects = [
  # Games Projects
  Project.create!(
    title: "ALIEN RPG - Evolved Edition",
    description: "Expanded and updated core rules and a new cinematic scenario for the award-winning RPG from Free League and 20th Century Studios. In space, no one can hear you scream.\n\nThis new edition features refined rules, expanded lore, and stunning new artwork that captures the terror and beauty of the ALIEN universe. Perfect for both new players and veterans alike.",
    goal: 500000,
    end_date: Date.today + 15.days,
    creator: admin,
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
    title: "QUBE: MENSA - Magnetic Puzzle Cube",
    description: "QUBE: Mensa is a hands-on journey through magnetic fields and mathematically sublime patterns. It's a tactile puzzle experience unlike any other.\n\nCombining powerful magnets with precision engineering, this puzzle cube offers a unique challenge that will test your spatial reasoning and problem-solving abilities.",
    goal: 50000,
    end_date: Date.today + 25.days,
    creator: users[3],
    status: "active",
    image_url: "https://images.unsplash.com/photo-1581091226033-d5c48150dbaa?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Technology"
  ),
  
  # Fashion Projects
  Project.create!(
    title: "The GAMEBAG - A Nostalgic, Fun ITA Satchel Bag",
    description: "Showcase your pins and wear your Gameboy with this satchel bag. Perfect for gamers, anime fans, and anyone who loves unique accessories.\n\nThe GAMEBAG features transparent display pockets for your collectible pins, enamel badges, or small toys. It's both a functional bag and a creative canvas to express your unique style.",
    goal: 15000,
    end_date: Date.today + 18.days,
    creator: users[4],
    status: "active",
    image_url: "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Fashion"
  ),
  
  # Comics Projects
  Project.create!(
    title: "WonderBox - Interactive Storytelling Game",
    description: "A narrative puzzle adventure that blends physical objects with digital storytelling. Each box contains a mystery that unfolds through objects, documents, and an interactive app.\n\nInspired by escape rooms and mystery boxes, WonderBox creates an immersive experience where players unravel a compelling story through physical clues and digital interactions.",
    goal: 30000,
    end_date: Date.today + 40.days,
    creator: users[5],
    status: "active",
    image_url: "https://images.unsplash.com/photo-1588497859490-85d1c17db96d?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Comics"
  ),
  
  # Publishing Projects - Funded but still active
  Project.create!(
    title: "Blood Over Bright Haven - Illustrated Deluxe Edition",
    description: "The award-winning dark fantasy novel returns in a deluxe illustrated edition with new content, artwork, and exclusive extras.\n\nThis special edition features 20 full-color illustrations by renowned fantasy artist Elena Dubrovskaya, a new epilogue by the author, and a cloth-bound hardcover with foil stamping.",
    goal: 10000,
    end_date: Date.today - 60.days,
    creator: users[6],
    status: "successful",
    image_url: "https://images.unsplash.com/photo-1611996575749-79a3a250f948?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Publishing"
  ),
  
  # Technology Project - Funded and fulfilled
  Project.create!(
    title: "EcoCharge - Solar Powered Charging Station",
    description: "A portable, solar-powered charging station for all your devices. Sustainable energy at your fingertips, anywhere you go.\n\nEcoCharge combines high-efficiency solar panels with fast-charging technology to keep your devices powered even in remote locations. Perfect for outdoor enthusiasts, travelers, and eco-conscious tech users.",
    goal: 75000,
    end_date: Date.today - 180.days,
    creator: users[7],
    status: "successful",
    image_url: "https://images.unsplash.com/photo-1617788138019-cfaf8abfbd41?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Technology"
  ),
  
  # Art Project - Failed to fund
  Project.create!(
    title: "Mythical Creatures Field Guide",
    description: "A beautifully illustrated compendium of mythical creatures from around the world, presented as a scientific field guide.\n\nPairing detailed illustrations with informative text, this guide catalogs over 100 mythical creatures with the same scientific rigor as a naturalist's handbook. A perfect blend of art, mythology, and imagination.",
    goal: 45000,
    end_date: Date.today - 30.days,
    creator: users[8],
    status: "failed",
    image_url: "https://images.unsplash.com/photo-1481487196290-c152efe083f5?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Art"
  ),
  
  # Film & Video Project
  Project.create!(
    title: "Time Travel Documentary",
    description: "An in-depth exploration of the science, fiction, and philosophy of time travel through interviews with physicists, philosophers, and sci-fi authors.\n\nThis feature-length documentary examines our fascination with time travel across cultures and disciplines, featuring stunning visualizations of complex temporal concepts and discussions with leading experts.",
    goal: 20000,
    end_date: Date.today + 30.days,
    creator: users[0],
    status: "active",
    image_url: "https://images.unsplash.com/photo-1610890716171-6b1bb98ffd09?ixlib=rb-4.0.3&w=600&h=400&fit=crop&q=80",
    category: "Film & Video"
  )
]

puts "Created #{Project.count} projects"
