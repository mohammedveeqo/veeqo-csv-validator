# Use the official Ruby image
FROM ruby:3.3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  sqlite3 \
  imagemagick \
  git \
  && apt-get clean

# Set environment variables
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_APP_CONFIG=/usr/local/bundle \
    RAILS_ENV=production

# Set working directory inside the container
WORKDIR /app

# Copy Gemfile and Gemfile.lock first for caching
COPY Gemfile Gemfile.lock /app/

# Install gems
RUN bundle install --without development test

# Copy the rest of the application code
COPY . /app

# Precompile assets (optional, for production environments)
RUN bundle exec rails assets:precompile

# Expose port 3000 to access the Rails app
EXPOSE 3000

# The command to run the application
CMD ["rails", "server", "-b", "0.0.0.0"]
