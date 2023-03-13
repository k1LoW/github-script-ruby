# frozen_string_literal: true

require 'test/unit'
require 'stringio'
require 'octokit'
require 'tempfile'
require_relative '../lib/github/actions/toolkit'

module GitHub
  module Actions
    module Toolkit
      class Runner
        def main
          github.contributors("k1LoW/github-script-ruby", true)
          'hello world'
        end
      end
    end
  end
end

class TestRunner < Test::Unit::TestCase
  def test_run
    t = Tempfile.open
    ENV['GITHUB_OUTPUT'] = t.path
    ENV['INPUT_RESULT_ENCODING'] = 'string'
    want = "::set-output name=result::hello world\n"
    GitHub::Actions::Toolkit::Runner.new.run
    got = t.read
    assert_equal want, got
    ENV['GITHUB_OUTPUT'] = nil
    t.unlink
  end

  def test_github
    got = GitHub::Actions::Toolkit::Runner.new.github
    assert_true got.is_a?(Octokit::Client)
  end

  def test_context
    want = 'test_context'
    ENV['GITHUB_ACTION'] = want
    got = GitHub::Actions::Toolkit::Runner.new.context.action
    assert_equal want, got
  end

  def test_core
    got = GitHub::Actions::Toolkit::Runner.new.core
    assert_true got.is_a?(GitHub::Actions::Toolkit::Core)
  end

  def test_debug
    ENV['INPUT_DEBUG'] = 'true'
    $stdout = StringIO.new
    GitHub::Actions::Toolkit::Runner.new.run
    got = $stdout.string
    $stdout = STDOUT
    ENV['INPUT_DEBUG'] = ''
    assert_true got.include? 'request: GET https://api.github.com/repos/k1LoW/github-script-ruby/contributors?anon=1&per_page=100'
  end
end
