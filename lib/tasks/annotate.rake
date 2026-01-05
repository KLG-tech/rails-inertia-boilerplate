# frozen_string_literal: true

# Annotate models, fixtures, and tests with schema information
# https://github.com/drwl/annotaterb
#
# Run manually with: bin/rails annotate_models
# Or generate config with: bin/rails g annotate_rb:install

if Rails.env.development?
  # Automatically annotate models after migrations
  Rake::Task["db:migrate"].enhance do
    Rake::Task["annotate_models"].invoke if Rake::Task.task_defined?("annotate_models")
  end

  Rake::Task["db:rollback"].enhance do
    Rake::Task["annotate_models"].invoke if Rake::Task.task_defined?("annotate_models")
  end
end
