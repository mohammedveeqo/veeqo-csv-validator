# Specifies the number of Puma workers to run. Each worker is a forked OS process.
# Workers are usually set to match the number of available CPU cores.
workers Integer(ENV.fetch('WEB_CONCURRENCY', 2))

# Threads are specified per worker.
min_threads_count = Integer(ENV.fetch('RAILS_MIN_THREADS', 5))
max_threads_count = Integer(ENV.fetch('RAILS_MAX_THREADS', 5))
threads min_threads_count, max_threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch('PORT', 3000)

# Specifies the environment Puma will run in.
environment ENV.fetch('RAILS_ENV', 'production')

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

# Specifies the location of Puma's state file.
state_path ENV.fetch('STATEFILE', 'tmp/pids/puma.state')

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Enable preload of the application for faster worker boot times.
preload_app!

# Configure worker timeout in development to allow longer debugging sessions.
worker_timeout 3600 if ENV.fetch('RAILS_ENV', 'development') == 'development'

# Configure hooks to manage connections and clean up before forking.
on_worker_boot do
  # Reconnect to database
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# Gracefully shut down workers on restart.
on_restart do
  puts 'Performing restart cleanup...'
end
