require_relative 'test_helper'

class TestMiniTestAdaptor < MiniTest::Unit::TestCase
  def setup 
    @env = Testify.env_defaults
    @runner = Testify::MiniTestAdaptor.new
  end

  def test_passing_tests
    @env[:files] = [File.join(File.dirname(__FILE__), 'dummy', 'pass_test.rb')]
    results = @runner.call @env
    assert_equal 2, results.size, "Wrong number of results"
    assert(results.all? {|r| r.status == :passed}, "Incorrect status(es) on passing tests")
  end

  def test_failing_tests
    @env[:files] = [File.join(File.dirname(__FILE__), 'dummy', 'fail_test.rb')]
    results = @runner.call @env
    assert_equal 2, results.size, "Wrong number of results"
    assert_equal 1, (results.select {|r| r.status == :passed}.size), "Incorrect number of passing tests"
    assert_equal 1, (results.select {|r| r.status == :failed}.size), "Incorrect number of failing tests"
  end

  def test_error_tests
    @env[:files] = [File.join(File.dirname(__FILE__), 'dummy', 'error_test.rb')]
    results = @runner.call @env
    assert_equal 2, results.size, "Wrong number of results"
    assert_equal 1, (results.select {|r| r.status == :passed}.size), "Incorrect number of passing tests"
    assert_equal 1, (results.select {|r| r.status == :error}.size), "Incorrect number of errors"
  end
end
