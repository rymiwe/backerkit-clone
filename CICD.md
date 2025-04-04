# CI/CD Pipeline for BackerKit Clone

This document outlines the Continuous Integration and Continuous Deployment pipeline set up with Semaphore CI for the BackerKit Clone project.

## Pipeline Overview

The pipeline consists of five main blocks:

1. **Setup** - Installs dependencies and sets up caching
2. **Code Quality** - Runs Rubocop to check code style and quality
3. **Tests** - Runs RSpec tests against the application
4. **Asset Precompilation Check** - Verifies assets can be precompiled successfully
5. **Deploy to Heroku** - Automatically deploys to Heroku when changes are pushed to main

## Setup Instructions

### 1. Create a Semaphore Account

Sign up for a free Semaphore CI account at [https://semaphoreci.com/](https://semaphoreci.com/).

### 2. Connect Your GitHub Repository

1. In the Semaphore dashboard, click "Create New"
2. Select your GitHub repository
3. Choose the workflow starter as "Single job"
4. Semaphore will use the `.semaphore/semaphore.yml` file we've already created

### 3. Set Up Secrets

Create a new secret called `backerkit-clone-secrets` with the following environment variables:

1. `HEROKU_API_KEY` - Your Heroku API key (find it in your Heroku account settings)

### 4. First Build

The pipeline will automatically start building on your next push to the repository.

## How It Works

### Automatic Testing

Every push to any branch will trigger the first three blocks (Setup, Code Quality, and Tests). This ensures code quality and functionality are maintained across all development branches.

### Automatic Deployment

When code is pushed to the `main` branch and all tests pass, Semaphore will automatically deploy the application to Heroku. This ensures that only tested, working code makes it to production.

## Troubleshooting

### Common Issues

- **Build Failures**: Check the specific error message in Semaphore's logs
- **Deployment Failures**: Verify your Heroku API key is correctly set up in Semaphore secrets
- **Test Failures**: Run tests locally with `bundle exec rspec` to debug

### Getting Help

If you encounter issues with the pipeline, refer to the [Semaphore documentation](https://docs.semaphoreci.com/) or reach out to the project maintainers.
