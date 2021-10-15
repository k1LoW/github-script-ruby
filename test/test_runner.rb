# frozen_string_literal: true

require 'test/unit'
require 'stringio'
require 'octokit'
require_relative '../lib/github/actions/toolkit'

module GitHub
  module Actions
    module Toolkit
      class Runner
        def main
          'hello world'
        end
      end
    end
  end
end

class TestRunner < Test::Unit::TestCase
  def test_run
    ENV['INPUT_RESULT_ENCODING'] = 'string'
    want = "::set-output name=result::hello world\n"
    $stdout = StringIO.new
    GitHub::Actions::Toolkit::Runner.new.run
    got = $stdout.string
    $stdout = STDOUT
    assert_equal want, got
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
end
