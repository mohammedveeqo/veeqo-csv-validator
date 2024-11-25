#!/usr/bin/env bash

# Install Node.js and Yarn if not already present
curl -sL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs
npm install -g yarn

# Run asset precompilation
bundle exec rails assets:precompile
