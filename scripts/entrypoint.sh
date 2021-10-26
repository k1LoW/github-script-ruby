#!/bin/sh -l

set -e

if [ -n "$INPUT_PRE_COMMAND" ]; then
    eval "$INPUT_PRE_COMMAND"
fi

if [ -n "$INPUT_GEMFILE" ]; then
    echo "$INPUT_GEMFILE" > /tmp/Gemfile
    cat /tmp/Gemfile
    bundle install --gemfile=/tmp/Gemfile
fi

bundle exec --gemfile=/github-script-ruby/Gemfile ruby /github-script-ruby/scripts/entrypoint.rb
