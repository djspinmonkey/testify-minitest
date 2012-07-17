class PassTest < MiniTest::Unit::TestCase
  def test_that_passes
    assert true
  end

  def test_that_also_passes
    assert_equal "2", 2.to_s
  end
end
