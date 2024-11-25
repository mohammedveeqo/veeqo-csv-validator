# Use this Dockerfile to create minimal reproductions of issues

FROM ruby:3.2
if [ "$SKIP_ASSET_PRECOMPILE" != "true" ]; then
  bundle exec rails assets:precompile
else
  echo "Skipping asset precompilation"
fi

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY . .

RUN bundle install
RUN bundle exec rake compile

EXPOSE 9292
CMD bundle exec bin/puma test/rackup/hello.ru
