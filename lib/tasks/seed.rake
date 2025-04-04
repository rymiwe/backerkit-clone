namespace :db do
  desc "Run all seed files in db/seeds directory in numerical order"
  task sequential_seed: :environment do
    puts "Cleaning the database..."
    # Clear existing data to avoid duplicates
    begin
      Pledge.destroy_all
      Reward.destroy_all
      Project.destroy_all
      User.destroy_all
      FulfillmentWave.destroy_all
      WaveItem.destroy_all
    rescue => e
      puts "Error during cleanup: #{e.message}"
    end

    # Load all seed files in order
    puts "Loading seed files..."

    # Load seed files in numerical order
    Dir[Rails.root.join('db', 'seeds', '*.rb')].sort.each do |file|
      puts "Loading seed file: #{file}"
      begin
        load file
      rescue => e
        puts "Error loading seed file #{file}: #{e.message}"
        puts e.backtrace.join("\n")
      end
    end

    puts ""
    puts "Seed data created successfully!"
    puts "You can log in with:"
    puts "Email: admin@example.com"
    puts "Password: password"
    puts ""
    puts "Or any of the sample users:"
    puts "Email: sarah@example.com, michael@example.com, etc."
    puts "Password: password"
  end

  desc "Run only the fulfillment waves seed file"
  task seed_fulfillment_waves: :environment do
    puts "Loading fulfillment waves seed file..."
    begin
      load Rails.root.join('db', 'seeds', '05_fulfillment_waves.rb')
      puts "Successfully created fulfillment waves"
    rescue => e
      puts "Error loading fulfillment waves seed file: #{e.message}"
      puts e.backtrace.join("\n")
    end
  end

  desc "Run a specific seed file by number (e.g. db:seed_file[01] for 01_users.rb)"
  task :seed_file, [:number] => :environment do |t, args|
    file_pattern = "#{args[:number]}*.rb"
    files = Dir[Rails.root.join('db', 'seeds', file_pattern)]
    
    if files.empty?
      puts "No seed files found matching: #{file_pattern}"
    else
      files.each do |file|
        puts "Loading seed file: #{file}"
        begin
          load file
          puts "Successfully loaded #{file}"
        rescue => e
          puts "Error loading seed file #{file}: #{e.message}"
          puts e.backtrace.join("\n")
        end
      end
    end
  end
end
