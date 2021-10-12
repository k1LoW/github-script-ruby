#!/bin/sh -l

set -e
bundle exec --gemfile=/github-script-ruby/Gemfile ruby /github-script-ruby/scripts/entrypoint.rb
