
# Adjust the number of Puma workers based on the environment.
# Use multiple workers in production but disable workers in development to avoid macOS fork issues.
workers Integer(ENV.fetch('WEB_CONCURRENCY', (ENV['RAILS_ENV'] == 'production' ? 2 : 0)))

# Threads are specified per worker. Adjust as needed.
min_threads_count = Integer(ENV.fetch('RAILS_MIN_THREADS', 5))
max_threads_count = Integer(ENV.fetch('RAILS_MAX_THREADS', 5))
threads min_threads_count, max_threads_count

# Specifies the `port` that Puma will listen on to receive requests.
port Integer(ENV.fetch('PORT', 3000))

# Specifies the environment Puma will run in. Default is production.
environment ENV.fetch('RAILS_ENV', 'production')

# Specifies the `pidfile` that Puma will use to track its process ID.
pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

# Specifies the location of Puma's state file.
state_path ENV.fetch('STATEFILE', 'tmp/pids/puma.state')

# Allow Puma to be restarted by the `bin/rails restart` command.
plugin :tmp_restart

# Preload the application for faster worker boot times, but disable it in development.
preload_app! unless ENV.fetch('WEB_CONCURRENCY', '0').to_i.zero?

# In development, increase worker timeout for debugging purposes.
worker_timeout 3600 if ENV.fetch('RAILS_ENV', 'development') == 'development'

# Configure hooks to manage connections and cleanup before forking workers.
on_worker_boot do
  # Reconnect to the database after worker boots.
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# Cleanup tasks before restarting Puma.
on_restart do
  puts 'Performing restart cleanup...'
end
