FROM ruby:3.3.0

ENV RAILS_MASTER_KEY=101ca01b64fe26ea91d8430ca70b7e96

RUN bundle exec rails assets:precompile

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  sqlite3 \
  imagemagick \
  git

# Set environment variables
ENV BUNDLE_PATH=/usr/local/bundle
ENV RAILS_ENV=production

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock /app/

# Install gems
RUN bundle install --without development test

# Copy application code
COPY . /app

# Precompile assets
RUN bundle exec rails assets:precompile

# Expose port
EXPOSE 3000

# Start the application
CMD ["rails", "server", "-b", "0.0.0.0"]
