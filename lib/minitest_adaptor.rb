module Testify
  # A Testify Framework to run MiniTest tests.  Or put another way, a
  # MiniTest::Unit runner that runs as a Testify framework.
  #
  # This is tied a more closely to the MiniTest::Unit implementation than is
  # ideal. Unfortunately, I don't see a good way to insert hooks around running
  # each individual test, so I've had to re-implement some of the surrounding
  # logic.
  #
  class MiniTestAdaptor < MiniTest::Unit
    include Testify::Framework

    aka :minitest
    statuses :passed, :failed, :error, :skipped
    file_pattern '*_test.rb'

    attr_accessor :results

    def call( env )
      self.results = []
      self._run
      results
    end

    ###### Below this line we are overriding MiniTest::Unit methods. ######
 
    def initialize
      super

      # squash output
      null_output = Object.new
      def null_output.puts(*_);  end
      def null_output.print(*_); end
      MiniTestAdaptor.output = null_output
    end

    # Run one MiniTest::Unit::TestCase's worth of tests
    #
    def _run_suite( suite, type )
      filter = options[:filter] || '/./'
      filter = Regexp.new $1 if filter =~ /\/(.*)\//

      assertions = suite.send("#{type}_methods").grep(filter).map do |method|
        inst = suite.new method
        inst._assertions = 0
        inst.run self

        # Failed, error, or skipped tests are handled in .puke.
        if inst.passed?
          result = Testify::TestResult.new(
            :status => :passed,
            # TODO: add the file and line
          ) 
          self.results << result
        end
        
        inst._assertions
      end

      return assertions.size, assertions.inject(:+)
    end

    # Handle any sort of non-passing test condition.
    #
    def puke klass, meth, e
      case e
      when MiniTest::Skip then
        @results << Testify::TestResult(
          :status => :skipped,
          :message => "Skipped:\n#{meth}(#{klass}) [#{location e}]:\n#{e.message}\n"
          # TODO: parse file and line out of location
        )
      when MiniTest::Assertion then
        @results << Testify::TestResult(
          :status => :failed,
          :message => "Failure:\n#{meth}(#{klass}) [#{location e}]:\n#{e.message}\n"
          # TODO: parse file and line out of location
        )
      else
        @results << Testify::TestResult(
          :status => :error,
          :message => "Error:\n#{meth}(#{klass}):\n#{e.class}: #{e.message}\n    #{bt}\n"
          # TODO: keep the backtrace: bt = MiniTest::filter_backtrace(e.backtrace).join "\n    "
          # TODO: parse file and line out of location
        )
      end

      return 'unused return value'
    end

  end
end
