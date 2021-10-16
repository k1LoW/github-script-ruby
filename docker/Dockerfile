FROM rubylang/ruby:2.7

LABEL org.opencontainers.image.url="https://github.com/k1LoW/github-script-ruby"
LABEL org.opencontainers.image.source="https://github.com/k1LoW/github-script-ruby/blob/main/baseimage/Dockerfile"

RUN apt-get update \
    && apt-get install -y $(apt-get list --upgradable | grep security | cut -f 1 -d "/" | xargs) \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo '#! /bin/sh' > /usr/bin/mesg && chmod 755 /usr/bin/mesg

COPY docker/Gemfile /github-script-ruby/Gemfile
COPY lib/ /github-script-ruby/lib/
COPY scripts/entrypoint.rb /github-script-ruby/scripts/entrypoint.rb
COPY scripts/entrypoint.sh /github-script-ruby/scripts/entrypoint.sh

RUN bundle install --gemfile=/github-script-ruby/Gemfile
