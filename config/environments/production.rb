Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This is necessary in most production setups.
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sassc

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Enable serving static files from the `/public` folder by default.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Use a different server-side cache store in production.
  # config.cache_store = :mem_cache_store

  # Configure SSL for production (uncomment to enforce SSL).
  # config.force_ssl = true

  # Logging configuration
  config.log_level = :debug
  config.log_tags = [:request_id]

  # Use default logging formatter.
  config.log_formatter = ::Logger::Formatter.new

  # Use a real queuing backend for Active Job.
  # config.active_job.queue_adapter = :sidekiq

  # Set up Action Mailer.
  # config.action_mailer.perform_caching = false
  # config.action_mailer.default_url_options = { host: 'example.com' }
end
