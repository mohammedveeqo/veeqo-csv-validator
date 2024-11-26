# Use the official Ruby image
FROM ruby:3.3.0

# Set environment variables
ENV RAILS_MASTER_KEY=101ca01b64fe26ea91d8430ca70b7e96
ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV BUNDLE_PATH=/usr/local/bundle

# Fix OpenSSL issue with Node.js
ENV NODE_OPTIONS="--openssl-legacy-provider"

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

# Copy the Gemfile and Gemfile.lock to the working directory
COPY Gemfile Gemfile.lock /app/

# Install gems
RUN bundle install --without development test

# Copy the application code
COPY . /app/

# Install Node.js dependencies
RUN yarn install

# Add necessary Webpack and Babel dependencies for Webpacker 5.x
RUN yarn add webpack@4 webpack-cli@3 babel-loader@8.2.5 \
    @babel/plugin-proposal-private-methods \
    @babel/plugin-proposal-class-properties \
    @babel/plugin-proposal-private-property-in-object --dev

# Precompile Webpacker assets
RUN bundle exec rails webpacker:compile

# Precompile Rails assets
RUN bundle exec rails assets:precompile

# Set the port that Puma will listen on
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
