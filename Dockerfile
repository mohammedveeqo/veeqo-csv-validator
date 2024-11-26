FROM ruby:3.3.0

# Set environment variables
ENV RAILS_MASTER_KEY=101ca01b64fe26ea91d8430ca70b7e96
ENV BUNDLE_PATH=/usr/local/bundle
ENV RAILS_ENV=production

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  curl \
  gnupg \
  sqlite3 \
  imagemagick \
  git

# Add Yarn's official repository and install the latest Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

# Set the working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock /app/

# Install gems
RUN bundle install --without development test

# Copy the application code
COPY . /app/

# Install Webpack and dependencies
RUN yarn install
RUN yarn add webpack webpack-cli

# Precompile assets
RUN bundle exec rails assets:precompile

# Expose port
EXPOSE 3000

# Start the application
CMD ["rails", "server", "-b", "0.0.0.0"]
