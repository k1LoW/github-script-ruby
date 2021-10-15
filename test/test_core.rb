# frozen_string_literal: true

require 'test/unit'
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
    core = GitHub::Actions::Toolkit::Core.new
    want = "::set-output name=prop::value\n"
    $stdout = StringIO.new
    core.set_output('prop', 'value')
    got = $stdout.string
    $stdout = STDOUT
    assert_equal want, got
  end

  def test_message
    core = GitHub::Actions::Toolkit::Core.new
    %w[
      debug
      error
      warning
      notice
    ].each do |c|
      want = "::#{c} ::something #{c}\n"
      $stdout = StringIO.new
      core.send(c, "something #{c}")
      got = $stdout.string
      $stdout = STDOUT
      assert_equal want, got
    end
  end

  def test_info
    core = GitHub::Actions::Toolkit::Core.new
    want = "something info\n"
    $stdout = StringIO.new
    core.info('something info')
    got = $stdout.string
    $stdout = STDOUT
    assert_equal want, got
  end

  def test_make_output
    core = GitHub::Actions::Toolkit::Core.new
    want = '::set-output name=prop::value'
    assert_equal want, core.make_output('set-output', 'prop', 'value')

    want = '::error ::value'
    assert_equal want, core.make_output('error', '', 'value')
  end
end
