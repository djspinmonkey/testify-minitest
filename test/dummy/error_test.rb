require_relative '../test_helper'

class ErrorTest < MiniTest::Unit::TestCase
  def test_that_passes
    assert "that this test passes"
  end

  def test_that_asplodes
    assert_equal "take cover!", KABOOM
  end
end
