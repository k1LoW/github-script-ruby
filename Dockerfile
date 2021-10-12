FROM ghcr.io/k1low/github-script-ruby-base:v0.1.0

COPY docker/Gemfile Gemfile
COPY lib/ /github-script-ruby/lib/
COPY scripts/entrypoint.rb /github-script-ruby/scripts/entrypoint.rb
COPY scripts/entrypoint.sh /github-script-ruby/scripts/entrypoint.sh

ENTRYPOINT ["/github-script-ruby/scripts/entrypoint.sh"]
