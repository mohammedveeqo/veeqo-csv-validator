Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Temporarily enable detailed error reporting for debugging
  config.consider_all_requests_local = true

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot.
  config.eager_load = true

  # Compress JavaScripts and CSS.
  config.assets.css_compressor = :sassc   # Use sassc for CSS compression
  config.assets.js_compressor = :terser   # Consider using Terser if you use modern JS

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false   # No dynamic compilation in production

  # Generate digests for assets URLs (for cache busting).
  config.assets.digest = true   # Essential for proper cache busting

  # Enable serving static files from the `/public` folder by default.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present? || Rails.env.production?

  # Enable caching in production
  config.action_controller.perform_caching = true

  # Log level for production.
  config.log_level = :info
  config.log_tags = [:request_id]

  # Use default logging formatter.
  config.log_formatter = ::Logger::Formatter.new

  # Enable serving of static files (images, JS, CSS).
  config.static_cache_control = "public, max-age=31536000"

  # Preload assets to improve initial loading speed.
  config.assets.preload = true

  # Ensure requests are served over SSL (optional).
  # config.force_ssl = true
end
