# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding database..."

# =============================================================================
# ROLES
# =============================================================================
# Create default roles for the application

default_roles = %w[admin user]

default_roles.each do |role_name|
  Role.find_or_create_by!(name: role_name) do |role|
    puts "  Created role: #{role_name}"
  end
end

puts "Roles: #{Role.pluck(:name).join(', ')}"

# =============================================================================
# ADMIN USER (Development/Test only, when Keycloak is not configured)
# =============================================================================
# Creates a default admin user for local development when Keycloak SSO is not set up.
# This user will NOT be created if:
#   - Running in production environment
#   - Keycloak environment variables are configured

keycloak_configured = ENV["KEYCLOAK_SITE_URL"].present? &&
                      ENV["KEYCLOAK_REALM"].present? &&
                      ENV["KEYCLOAK_CLIENT_ID"].present?

if Rails.env.production?
  puts "Skipping admin user creation in production environment."
  puts "Use Keycloak SSO or create users through the application."
elsif keycloak_configured
  puts "Keycloak is configured. Skipping local admin user creation."
  puts "Users will authenticate via Keycloak SSO."
else
  # Only create admin user if User model has Devise authentication
  if User.respond_to?(:find_or_create_by!) && User.new.respond_to?(:email=)
    admin_email = "admin@example.com"
    admin_password = "password123"

    admin = User.find_or_initialize_by(email: admin_email)

    if admin.new_record?
      # Check if password field exists (Devise is configured with database_authenticatable)
      if admin.respond_to?(:password=)
        admin.password = admin_password
        admin.password_confirmation = admin_password if admin.respond_to?(:password_confirmation=)
      end

      admin.save!
      admin.add_role(:admin)

      puts ""
      puts "=" * 60
      puts "Development Admin User Created"
      puts "=" * 60
      puts "  Email:    #{admin_email}"
      puts "  Password: #{admin_password}"
      puts ""
      puts "  WARNING: This user is for development only!"
      puts "  Do NOT use these credentials in production."
      puts "=" * 60
      puts ""
    else
      # Ensure existing admin has the admin role
      admin.add_role(:admin) unless admin.has_role?(:admin)
      puts "Admin user already exists: #{admin_email}"
    end
  else
    puts "User model does not support email/password authentication."
    puts "Configure Devise or Keycloak for user authentication."
  end
end

puts ""
puts "Seeding complete!"
