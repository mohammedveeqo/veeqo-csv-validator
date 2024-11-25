#!/usr/bin/env bash
# Exit on error
set -o errexit

bundle install
bundle exec rake assets:clean

if [ "$SKIP_ASSET_PRECOMPILE" != "true" ]; then
  echo "Precompiling assets..."
  bundle exec rails assets:precompile
else
  echo "Skipping asset precompilation"
fi