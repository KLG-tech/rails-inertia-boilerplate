# frozen_string_literal: true

Rolify.configure do |config|
  # By default, rolify dynamically defines methods based on roles like `is_admin?`
  # You can enable dynamic shortcuts below:
  # config.use_dynamic_shortcuts

  # By default, ORM adapter is ActiveRecord. Uncomment to use Mongoid:
  # config.use_mongoid

  # Remove a role from the database if it's not assigned to any resource
  # By default this is set to false:
  # config.remove_role_if_empty = true
end
