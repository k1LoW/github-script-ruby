FROM rubylang/ruby:2.7

LABEL org.opencontainers.image.url="https://github.com/k1LoW/github-script-ruby"
LABEL org.opencontainers.image.source="https://github.com/k1LoW/github-script-ruby/blob/main/baseimage/Dockerfile"

RUN echo '#! /bin/sh' > /usr/bin/mesg && chmod 755 /usr/bin/mesg

COPY baseimage/Gemfile Gemfile
COPY lib/ /github-script-ruby/lib/
COPY scripts/entrypoint.rb /github-script-ruby/scripts/entrypoint.rb
COPY scripts/entrypoint.sh /github-script-ruby/scripts/entrypoint.sh

RUN bundle install
