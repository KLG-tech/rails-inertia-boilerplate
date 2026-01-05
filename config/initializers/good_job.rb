# frozen_string_literal: true

Rails.application.configure do
  config.good_job.preserve_job_records = true
  config.good_job.retry_on_unhandled_error = false
  config.good_job.on_thread_error = ->(exception) { Rails.error.report(exception) }

  # Execution mode configuration
  # - :async executes jobs in the Rails process in a background thread pool
  # - :external requires running `bundle exec good_job start`
  config.good_job.execution_mode = Rails.env.development? ? :async : :external

  # Queue priority configuration
  config.good_job.queues = "*"

  # Maximum number of threads to use for job execution (in async mode)
  config.good_job.max_threads = ENV.fetch("GOOD_JOB_MAX_THREADS", 5).to_i

  # Interval between checking for jobs to run (in seconds)
  config.good_job.poll_interval = ENV.fetch("GOOD_JOB_POLL_INTERVAL", 5).to_i

  # Enable cron-like scheduled jobs
  config.good_job.enable_cron = true

  # Cleanup settings - preserve finished jobs for a limited time
  config.good_job.cleanup_preserved_jobs_before_seconds_ago = 14.days.to_i
  config.good_job.cleanup_interval_jobs = 1000
  config.good_job.cleanup_interval_seconds = 10.minutes.to_i

  # Dashboard configuration
  # The dashboard is mounted in config/routes.rb
  # Example: mount GoodJob::Engine => "/good_job"

  # Cron jobs configuration (example)
  # config.good_job.cron = {
  #   example_task: {
  #     cron: "0 * * * *", # Every hour
  #     class: "ExampleJob",
  #     description: "Example scheduled job"
  #   }
  # }
end
