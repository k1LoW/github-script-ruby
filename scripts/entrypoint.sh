#!/bin/sh -l

set -e

if [ -n "$INPUT_PRE_COMMAND" ]; then
    eval "$INPUT_PRE_COMMAND"
fi

if [ -n "$INPUT_RUBY_VERSION" ]; then
    mkdir -p /opt/hostedtoolcache/Ruby/$INPUT_RUBY_VERSION
    curl -sL https://github.com/ruby/ruby-builder/releases/download/toolcache/ruby-$INPUT_RUBY_VERSION-ubuntu-20.04.tar.gz --output /tmp/ruby.tar.gz
    tar -xz -C /opt/hostedtoolcache/Ruby/$INPUT_RUBY_VERSION -f /tmp/ruby.tar.gz
    export PATH=/opt/hostedtoolcache/Ruby/$INPUT_RUBY_VERSION/x64/bin:$PATH
    rm -f /github/workspace/Gemfile.lock /github-script-ruby/Gemfile.lock
    if ruby -e "exit 1 unless Gem::Version.create(RUBY_VERSION) < Gem::Version.create('2.6')"; then
        gem install bundler --no-document
        gem update --system --no-document
    fi
    bundle install --gemfile=/github-script-ruby/Gemfile
    ruby -v
    gem -v
    bundle -v
fi

if [ -n "$INPUT_GEMFILE" ]; then
    echo "$INPUT_GEMFILE" > /tmp/Gemfile
    cat /tmp/Gemfile
    bundle install --gemfile=/tmp/Gemfile
elif [ -n "$INPUT_GEMFILE_PATH" ]; then
    bundle install --gemfile=$INPUT_GEMFILE_PATH
fi

if [ -n "$INPUT_COMMAND" ]; then
    eval "$INPUT_COMMAND"
else
    bundle exec --gemfile=/github-script-ruby/Gemfile ruby /github-script-ruby/scripts/entrypoint.rb
fi
