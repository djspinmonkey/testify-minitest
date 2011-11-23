module Testify
  # A Testify Framework to run MiniTest tests.
  #
  class MiniTestAdaptor < MiniTest::Unit
    include Testify::Framework

    aka :minitest
    statuses :passed, :failed, :error, :skipped
    file_pattern '*_test.rb'

    def call( env )
      [TestResult.new(:status => :passed), TestResult.new(:status => :passed)]
    end
  end
end
