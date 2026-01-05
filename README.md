# Rails Inertia Boilerplate

A modern, production-ready boilerplate for building full-stack web applications with **Rails 8.1**, **Inertia.js**, **Vue 3**, and **Tailwind CSS**.

## Overview

This boilerplate provides a solid foundation for building modern web applications that combine the power of Rails on the backend with a reactive Vue.js frontend, seamlessly connected through Inertia.js. No API required - build SPAs with the simplicity of traditional server-rendered apps.

## Tech Stack

### Backend
- **Rails 8.1** - Full-featured web framework
- **PostgreSQL** - Primary database
- **Good Job** - PostgreSQL-based background job processing
- **Devise** - Flexible authentication solution
- **OmniAuth Keycloak** - SSO authentication via Keycloak
- **Rolify** - Role management
- **Pundit** - Policy-based authorization
- **Pagy** - Fast pagination

### Frontend
- **Vue 3** - Progressive JavaScript framework
- **Inertia.js** - SPA without building an API
- **Vite** - Next-generation frontend build tool
- **Tailwind CSS 3** - Utility-first CSS framework
- **HeadlessUI** - Unstyled, accessible UI components
- **Heroicons** - Beautiful hand-crafted SVG icons
- **TypeScript** - Type-safe JavaScript

### Production & Monitoring
- **Kamal** - Zero-downtime Docker deployments
- **Thruster** - HTTP asset caching/compression
- **New Relic** - Application performance monitoring
- **Lograge** - Structured logging
- **Rack Attack** - Rate limiting and throttling
- **Rack CORS** - Cross-Origin Resource Sharing

### Development & Testing
- **RuboCop** - Ruby static code analyzer
- **ESLint** - JavaScript linting
- **Prettier** - Code formatting
- **Brakeman** - Security vulnerability scanner
- **Bundler Audit** - Gem security auditing
- **Lefthook** - Git hooks manager
- **Capybara** - Integration testing
- **Selenium** - Browser automation for system tests

## Prerequisites

- **Ruby** 3.2.2 (see `.ruby-version`)
- **Node.js** 20.x or later
- **PostgreSQL** 16+ (17 recommended)
- **Redis/Valkey** 8+ (for Action Cable in production)

## Setup

### 1. Clone the repository

```bash
git clone <repository-url>
cd rails-inertia-boilerplate
```

### 2. Install dependencies

```bash
# Install Ruby gems
bundle install

# Install Node.js packages
npm install
```

### 3. Configure environment variables

```bash
# Copy the example environment file
cp .env.example .env

# Edit .env with your configuration
```

### 4. Setup the database

```bash
# Create databases
bin/rails db:create

# Run migrations
bin/rails db:migrate

# Seed initial data (roles and optional admin user)
bin/rails db:seed
```

### 5. Start development servers

```bash
# Terminal 1: Start Rails server
bin/rails server

# Terminal 2: Start Vite dev server (for hot module replacement)
npm run dev
```

Or use Docker Compose for the database:

```bash
# Start PostgreSQL and Redis containers
docker compose up -d postgres redis

# Then run Rails and Vite as above
```

## Environment Variables

Copy `.env.example` to `.env` and configure the following variables:

### Database Configuration
| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | Full database connection URL (production) | - |
| `DATABASE_HOST` | Database host | `localhost` |
| `DATABASE_PORT` | Database port | `5432` |
| `DATABASE_NAME` | Database name | `rails_inertia_boilerplate_development` |
| `DATABASE_USERNAME` | Database username | - |
| `DATABASE_PASSWORD` | Database password | - |
| `RAILS_MAX_THREADS` | Database connection pool size | `5` |

### Keycloak Authentication (Optional)
| Variable | Description | Default |
|----------|-------------|---------|
| `KEYCLOAK_SITE_URL` | Keycloak server URL | - |
| `KEYCLOAK_REALM` | Keycloak realm name | - |
| `KEYCLOAK_CLIENT_ID` | OAuth client ID | - |
| `KEYCLOAK_CLIENT_SECRET` | OAuth client secret | - |

### Monitoring (Optional)
| Variable | Description | Default |
|----------|-------------|---------|
| `NEW_RELIC_LICENSE_KEY` | New Relic license key | - |
| `NEW_RELIC_APP_NAME` | Application name in New Relic | - |

### Background Jobs
| Variable | Description | Default |
|----------|-------------|---------|
| `GOOD_JOB_MAX_THREADS` | Max threads for job processing | `5` |
| `GOOD_JOB_POLL_INTERVAL` | Job polling interval (seconds) | `5` |

### Redis/Action Cable
| Variable | Description | Default |
|----------|-------------|---------|
| `REDIS_URL` | Redis connection URL | `redis://localhost:6379/1` |

### Application
| Variable | Description | Default |
|----------|-------------|---------|
| `RAILS_ENV` | Rails environment | `development` |
| `RAILS_MASTER_KEY` | Encryption key for credentials | - |
| `RAILS_LOG_LEVEL` | Log verbosity level | `debug` / `info` |
| `PORT` | Web server port | `3000` |
| `WEB_CONCURRENCY` | Number of Puma workers | - |

## Development Commands

### Rails Server
```bash
bin/rails server           # Start Rails server on port 3000
bin/rails console          # Start Rails console
bin/rails routes           # List all routes
```

### Frontend Development
```bash
npm run dev                # Start Vite dev server with HMR
npm run build              # Build production assets
npm run preview            # Preview production build
npm run lint               # Run ESLint
npm run format             # Run Prettier
```

### Database
```bash
bin/rails db:create        # Create databases
bin/rails db:migrate       # Run pending migrations
bin/rails db:seed          # Seed the database
bin/rails db:reset         # Drop, create, migrate, and seed
```

### Background Jobs
```bash
# In development, Good Job runs in async mode within the Rails process
# In production, run the job worker separately:
bundle exec good_job start
```

### Code Quality
```bash
bin/rubocop                # Run Ruby linter
bin/brakeman               # Run security scanner
bin/bundler-audit          # Check for vulnerable gems
npx eslint .               # Run JavaScript linter
npx prettier --check .     # Check code formatting
```

## Testing Commands

### Run All Tests
```bash
bin/rails test             # Run unit and integration tests
bin/rails test:system      # Run system tests (browser-based)
bin/rails test:all         # Run all tests including system tests
```

### Run Specific Tests
```bash
bin/rails test test/models                    # Run model tests
bin/rails test test/controllers               # Run controller tests
bin/rails test test/models/user_test.rb       # Run a specific test file
bin/rails test test/models/user_test.rb:10    # Run a specific test line
```

### Parallel Testing
```bash
bin/rails test TESTOPTS="--parallelize-workers=4"
```

## CI/CD

This project includes GitHub Actions workflows for:

- **CI** (`ci.yml`): Runs on every push and PR
  - Security scanning (Brakeman, Bundler Audit, npm audit)
  - Unit and integration tests
  - System tests with artifact upload on failure

- **Lint** (`lint.yml`): Code quality checks

## Deployment (Kamal)

This project is configured for deployment with [Kamal](https://kamal-deploy.org/).

### Setup Deployment

1. Configure `config/deploy.yml` with your server details
2. Set up secrets in `.kamal/secrets`
3. Ensure your server has Docker installed

### Deploy Commands

```bash
bin/kamal setup            # First-time server setup
bin/kamal deploy           # Deploy the application
bin/kamal redeploy         # Redeploy without setup
bin/kamal rollback         # Rollback to previous version
```

### Useful Kamal Aliases

```bash
bin/kamal console          # Open Rails console on server
bin/kamal shell            # Open bash shell on server
bin/kamal logs             # Tail application logs
bin/kamal dbc              # Open database console
```

### Docker Compose (Local Production Testing)

```bash
# Build and run the full stack locally
docker compose up --build

# Access at http://localhost:3000
```

## Project Structure

```
.
├── app/
│   ├── controllers/       # Rails controllers
│   ├── models/            # ActiveRecord models
│   ├── policies/          # Pundit authorization policies
│   ├── jobs/              # Background jobs (Good Job)
│   └── frontend/          # Vue.js components and pages
├── config/
│   ├── deploy.yml         # Kamal deployment configuration
│   ├── database.yml       # Database configuration
│   └── initializers/      # Rails initializers
├── db/
│   ├── migrate/           # Database migrations
│   └── seeds.rb           # Seed data
├── .github/
│   └── workflows/         # GitHub Actions CI/CD
└── docker-compose.yml     # Local development services
```

## Authorization

This boilerplate uses **Rolify** for role management and **Pundit** for policy-based authorization.

### Default Roles
- `admin` - Full system access
- `user` - Standard user access

### Example Usage

```ruby
# Assign a role
user.add_role :admin

# Check role
user.has_role? :admin

# In policies (app/policies/)
class PostPolicy < ApplicationPolicy
  def update?
    user.has_role?(:admin) || record.user == user
  end
end
```

## Authentication

Authentication is handled by **Devise** with optional **Keycloak** SSO integration.

### Local Authentication
Standard email/password authentication is available out of the box.

### Keycloak SSO
To enable Keycloak authentication:
1. Set up a Keycloak server
2. Create a realm and client
3. Configure the environment variables (see above)

## License

This project is available as open source under the terms of the MIT License.
