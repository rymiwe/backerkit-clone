# BackerKit Clone

A functional demonstration app that simulates BackerKit's crowdfunding platform management system with a focus on partial fulfillment tracking. This application allows project creators to manage their crowdfunding campaigns and backers to pledge to projects they're interested in.

## Live Demo

Visit the live demo at: [https://backerkit-clone-ac3c300c1e50.herokuapp.com/](https://backerkit-clone-ac3c300c1e50.herokuapp.com/)

## Features

- **Project Management**: Create and manage crowdfunding projects with reward tiers
- **Backer Pledging**: Users can back projects and select rewards
- **Reward Fulfillment Dashboard**: Track and update the status of reward production and shipping
- **Partial Fulfillment System**: Manage item-level fulfillment with the following features:
  - **Fulfillment Waves**: Group items for batch production and shipment
  - **Backer-Level Tracking**: Track which items have been shipped to which backers
  - **Progress Visualization**: See fulfillment status and progress at a glance

## CI/CD Pipeline & Deployment

This project implements a professional CI/CD pipeline using the same technologies as the actual BackerKit platform:

### Semaphore CI/CD

The application uses Semaphore CI for continuous integration and deployment with a multi-stage pipeline:

- **Setup**: Installs dependencies and caches them for faster subsequent builds
- **Code Quality**: Runs code linting and style checks with Rubocop
- **Tests**: Executes RSpec tests for models and controllers, including:
  - Core model functionality tests
  - Fulfillment tracking system tests
  - Controller tests for the fulfillment dashboard
- **Asset Compilation**: Verifies that assets compile successfully
- **Deployment**: Uses a promotion-based workflow to deploy to Heroku

### Heroku Deployment

The application is automatically deployed to Heroku when changes are pushed to the main branch and all tests pass:

- **Database Migrations**: Automatically run during the release phase
- **Asset Precompilation**: Handled by the Heroku Ruby buildpack
- **Environment Variables**: Managed securely through Semaphore secrets

View the Semaphore configuration in the `.semaphore` directory to see how the pipeline is structured.

## Demo Accounts

All accounts use the password: `password`

### Creator Accounts

| Email | Projects |
|-------|----------|
| admin@example.com | Eco-Friendly Water Bottle, Handcrafted Leather Journals |
| sarah@example.com | Ultimate Cooking Guide, Custom Wooden Desk Organizer |
| michael@example.com | Modular Desk Lamp, Time Travel Documentary |
| emily@example.com | Pocket-Sized Adventure Camera |
| david@example.com | EcoCharge - Solar Powered Charging Station |
| jessica@example.com | Urban Perspectives - Street Art Photography Book |

### Backer Accounts

All user accounts have made pledges to various projects. To see which projects a user has backed, log in and click on "My Pledges" in the navigation menu.

## Testing the Fulfillment Dashboard

1. **Log in** with a creator account (e.g., admin@example.com)
2. Navigate to **My Projects**
3. Select a project
4. Click on the **Fulfillment Dashboard** button
5. From the dashboard you can:
   - View overall fulfillment progress
   - Create fulfillment waves
   - Update reward and item fulfillment statuses
   - Track individual backer fulfillment

### Example Fulfillment Workflow

1. Log in as `admin@example.com`
2. Go to the "Eco-Friendly Water Bottle" project
3. Click "Fulfillment Dashboard"
4. Create a new fulfillment wave for a batch of items
5. Update the fulfillment status for specific backers

## Technology Stack

- **Backend**: Ruby on Rails 7.1
- **Database**: PostgreSQL
- **Frontend**: 
  - Tailwind CSS for styling
  - Stimulus JS for interactivity
  - Hotwire for real-time updates
- **CI/CD & DevOps**:
  - Semaphore CI/CD for continuous integration and deployment
  - Heroku for cloud hosting and production deployment
  - Git for version control

## Test Coverage

The application includes comprehensive test coverage for:

- **Models**: User, Project, Reward, Pledge with associated validations and methods
- **Controllers**: FulfillmentDashboard and Rewards controllers
- **Core Functionality**: Fulfillment tracking, backer management, and project status

Run the test suite with:

```bash
bundle exec rspec
```

## Local Development

### Prerequisites

- Ruby 3.3.1
- Rails 7.1.5
- PostgreSQL

### Setup

```bash
# Clone the repository
git clone <repository-url>
cd backerkit_clone

# Install dependencies
bundle install

# Setup the database
rails db:create db:migrate db:seed

# Start the server
rails server
```

## Acknowledgments

This is a demonstration application created for educational purposes. It is not affiliated with the actual BackerKit platform.
