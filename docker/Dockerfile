FROM rubylang/ruby:3.3-dev-jammy

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

RUN gem install bundler \
    # CVE-2025-61594: Update the uri default gem and remove the old gemspec
    # because `gem install` leaves it in specifications/default/
    && gem install uri -v '~> 0.13.3' \
    && rm -f /usr/local/lib/ruby/gems/*/specifications/default/uri-*.gemspec \
    # CVE-2026-41316: Update the erb default gem and remove the old gemspec.
    && gem install erb -v '~> 4.0.3.1' \
    && rm -f /usr/local/lib/ruby/gems/*/specifications/default/erb-*.gemspec \
    # CVE-2026-42245 / CVE-2026-42246 / CVE-2026-42257 / CVE-2026-42258:
    # net-imap is a bundled gem (not a default gem) in Ruby 3.3, so the
    # pre-installed copy lives in specifications/ rather than
    # specifications/default/. `gem install` does not replace it, so
    # uninstall the vulnerable version explicitly.
    && gem install net-imap -v '~> 0.4.24' \
    && gem uninstall net-imap --version 0.4.21 --force --executables

RUN bundle install --gemfile=/github-script-ruby/Gemfile
