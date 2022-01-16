FROM rubylang/ruby:3.1-focal

LABEL org.opencontainers.image.url="https://github.com/k1LoW/github-script-ruby"
LABEL org.opencontainers.image.source="https://github.com/k1LoW/github-script-ruby/blob/main/docker/Dockerfile"

RUN apt-get update \
    && apt-get install -y curl unattended-upgrades \
    && unattended-upgrade \
    && apt-get purge -y unattended-upgrades \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo '#! /bin/sh' > /usr/bin/mesg && chmod 755 /usr/bin/mesg

COPY docker/Gemfile /github-script-ruby/Gemfile
COPY lib/ /github-script-ruby/lib/
COPY scripts/entrypoint.rb /github-script-ruby/scripts/entrypoint.rb
COPY scripts/entrypoint.sh /github-script-ruby/scripts/entrypoint.sh

RUN gem install bundler -v 2.3.5 && gem update --system

RUN bundle install --gemfile=/github-script-ruby/Gemfile
