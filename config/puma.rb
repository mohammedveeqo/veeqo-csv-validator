# Specifies the number of Puma workers to run. Each worker is a forked OS process.
# Adjust the workers based on your CPU cores and memory constraints. Defaults to 2.
workers Integer(ENV.fetch('WEB_CONCURRENCY', 2))

# Threads are specified per worker. Adjust the minimum and maximum threads based on your application's needs.
min_threads_count = Integer(ENV.fetch('RAILS_MIN_THREADS', 5))
max_threads_count = Integer(ENV.fetch('RAILS_MAX_THREADS', 5))
threads min_threads_count, max_threads_count

# Specifies the `port` that Puma will listen on to receive requests.
# Ensure this matches the port expected by Render (e.g., 10000).
port ENV.fetch('PORT', 10000)

# Specifies the environment Puma will run in. Default is production.
environment ENV.fetch('RAILS_ENV', 'production')

# Specifies the `pidfile` that Puma will use to track its process ID.
pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

# Specifies the location of Puma's state file.
state_path ENV.fetch('STATEFILE', 'tmp/pids/puma.state')

# Allow Puma to be restarted by the `bin/rails restart` command.
plugin :tmp_restart

# Preload the application for faster worker boot times.
preload_app!

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
