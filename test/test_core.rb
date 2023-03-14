# frozen_string_literal: true

require 'test/unit'
require 'tempfile'
require 'stringio'
require_relative '../lib/github/actions/toolkit'

class TestCore < Test::Unit::TestCase
  def test_get_input
    core = GitHub::Actions::Toolkit::Core.new
    want = 'Hello, world!'
    ENV['INPUT_HELLO'] = want
    assert_equal want, core.get_input('hello')
  end

  def test_get_input_hyphen
    # Ruby can get environment variables with hyphenated names,
    # but it cannot get environment variables with hyphenated names via docker command
    core = GitHub::Actions::Toolkit::Core.new
    want = 'Hello, world!'
    ENV['INPUT_INPUT-VALUE'] = want
    assert_equal want, core.get_input('input-value')
  end

  def test_set_output
    t = Tempfile.open
    ENV['GITHUB_OUTPUT'] = t.path
    core = GitHub::Actions::Toolkit::Core.new
    want = "prop=value\n"
    core.set_output('prop', 'value')
    got = t.read
    assert_equal want, got
    ENV['GITHUB_OUTPUT'] = nil
    t.unlink
  end

  def test_message
    core = GitHub::Actions::Toolkit::Core.new
    %w[
      debug
      error
      warning
      notice
    ].each do |c|
      $stdout = StringIO.new
      want = "::#{c} ::something #{c}\n"
      core.send(c, "something #{c}")
      got = $stdout.string
      $stdout = STDOUT
      assert_equal want, got
    end
  end

  def test_info
    $stdout = StringIO.new
    core = GitHub::Actions::Toolkit::Core.new
    want = "something info\n"
    core.info('something info')
    got = $stdout.string
    $stdout = STDOUT
    assert_equal want, got
  end

  def test_make_output
    core = GitHub::Actions::Toolkit::Core.new
    want = '::error ::value'
    assert_equal want, core.make_output('error', 'value')
  end
end
