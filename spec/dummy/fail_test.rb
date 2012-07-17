class FailTest < MiniTest::Unit::TestCase
  def test_that_passes
    assert true
  end

  def test_that_fails
    refute "Ruh roh.", "This test should fail."
  end
end
