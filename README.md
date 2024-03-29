# github-script-ruby [![Test](https://github.com/k1LoW/github-script-ruby/actions/workflows/test.yml/badge.svg)](https://github.com/k1LoW/github-script-ruby/actions/workflows/test.yml) ![Coverage](https://raw.githubusercontent.com/k1LoW/octocovs/main/badges/k1LoW/github-script-ruby/coverage.svg) ![Code to Test Ratio](https://raw.githubusercontent.com/k1LoW/octocovs/main/badges/k1LoW/github-script-ruby/ratio.svg) ![Test Execution Time](https://raw.githubusercontent.com/k1LoW/octocovs/main/badges/k1LoW/github-script-ruby/time.svg)

This action makes it easy to write Ruby scripts in the workflow, just like [actions/github-script](https://github.com/actions/github-script).

In order to use this action, a `script` input is provided. The value of that input should be the body of an function call. The following arguments will be provided:

- `github` A pre-authenticated [octokit.rb](https://github.com/octokit/octokit.rb) client with `auto_paginate=true`
- `context` An OpenStruct instance containing the context of the workflow run
- `core` An instance of [GitHub::Actions::Toolkit::Core](lib/github/actions/toolkit/core.rb)

## Examples

### Print the available attributes of context

ref: [actions/github-script example](https://github.com/actions/github-script#print-the-available-attributes-of-context)

``` yaml
- name: View context attributes
  uses: k1LoW/github-script-ruby@v2
  with:
    script: pp context
```
### Comment on an issue

ref: [actions/github-script example](https://github.com/actions/github-script#comment-on-an-issue)

``` yaml
on:
  issues:
    types: [opened]

jobs:
  comment:
    runs-on: ubuntu-latest
    steps:
      - uses: k1LoW/github-script-ruby@v2
        with:
          script: |
            repo = "#{context.repo.owner}/#{context.repo.repo}"
            number = context.issue.number
            comment = '👋 Thanks for reporting!'
            github.add_comment(repo, number, comment)
```

### Use Gem packages

It is possible to change the Gemfile to use.

If you want to use octokit.rb, don't forget to add it.

``` yaml
- name: 'Post message to Slack #general channel'
  uses: k1LoW/github-script-ruby@v2
  with:
    script: |
      require 'slack-ruby-client'
      Slack.configure do |config|
        config.token = ENV['SLACK_API_TOKEN']
      end
      client = Slack::Web::Client.new
      client.chat_postMessage(channel: '#general', text: 'Hello, Slack bot!')
    gemfile: |
      source 'https://rubygems.org'
      gem 'octokit', '~> 4.0'
      gem 'slack-ruby-client'
  env:
    SLACK_API_TOKEN: ${{ secrets.SLACK_API_TOKEN }}
```

### Pre-install packages for building native extentions.

``` yaml
- name: 'List users'
  uses: k1LoW/github-script-ruby@v2
  with:
    script: |
      require 'mysql2'
      client = Mysql2::Client.new(:host => "localhost", :username => "root")
      client.query('SELECT * FROM users').each do |row|
        puts row['name']
      end
    pre-command: |
      apt-get update
      apt-get install -y libmysqld-dev
    gemfile: |
      source 'https://rubygems.org'
      gem 'mysql2'
```

### Change Ruby version of use

``` yaml
- name: 'Hello Ruby version'
  uses: k1LoW/github-script-ruby@v2
  with:
    script: |
      repo = "#{context.repo.owner}/#{context.repo.repo}"
      number = context.issue.number
      comment = "Hello using Ruby v#{RUBY_VERSION}"
      github.add_comment(repo, number, comment)
    ruby-version: 2.7.5
```

The `ruby-version:` feature is realized using the prebuilt Ruby releases are generated by [ruby-builder](https://github.com/ruby/ruby-builder)

### Execute Ruby script file

``` yaml
- name: 'Capistrano deploy'
  uses: k1LoW/github-script-ruby@v2
  with:
    gemfile-path: path/to/Gemfile
    command: bundle exec cap deploy --gemfile=path/to/Gemfile
    ruby-version: 2.7.5
```

## References

- [actions/github-script](https://github.com/actions/github-script): Write workflows scripting the GitHub API in JavaScript
- [ruby/setup-ruby](https://github.com/ruby/setup-ruby): An action to download a prebuilt Ruby and add it to the PATH in 5 seconds
