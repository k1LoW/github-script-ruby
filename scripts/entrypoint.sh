#!/bin/sh -l

set -e

if [ -n "$INPUT_PRE_COMMAND" ]; then
    eval "$INPUT_PRE_COMMAND"
fi

if [ -n "$RUBY_VERSION" ]; then
    mkdir -p /opt/hostedtoolcache/Ruby/$RUBY_VERSION
    curl -sL https://github.com/ruby/ruby-builder/releases/download/toolcache/ruby-$RUBY_VERSION-ubuntu-20.04.tar.gz --output /tmp/ruby.tar.gz
    tar -xz -C /opt/hostedtoolcache/Ruby/$RUBY_VERSION -f /tmp/ruby.tar.gz
    export PATH=/opt/hostedtoolcache/Ruby/$RUBY_VERSION/x64/bin:$PATH
    bundle install --gemfile=/github-script-ruby/Gemfile
fi

if [ -n "$INPUT_GEMFILE" ]; then
    echo "$INPUT_GEMFILE" > /tmp/Gemfile
    cat /tmp/Gemfile
    bundle install --gemfile=/tmp/Gemfile
fi

bundle exec --gemfile=/github-script-ruby/Gemfile ruby /github-script-ruby/scripts/entrypoint.rb
