require_relative 'spec_helper'

describe Testify::MiniTestAdaptor do
  before do
    @env = Testify.env_defaults
    @runner = Testify::MiniTestAdaptor.new
  end

  context 'with all tests passing' do
    before { @env[:files] = [File.join(File.dirname(__FILE__), 'dummy', 'pass_test.rb')] }
    subject { @runner.call @env }

    it { should have(2).test_results }

    its("collect(&:status)") { should all_be :passed }
  end

  context 'with some tests failing' do
    before { @env[:files] = [File.join(File.dirname(__FILE__), 'dummy', 'fail_test.rb')] }
    subject { @runner.call @env }

    it { should have(2).test_results }

    it "should have 1 passing test" do
      subject.select {|r| r.status == :passed}.should have(1).test_result
    end

    it "should have 1 failing test" do
      subject.select {|r| r.status == :failed}.should have(1).test_result
    end
  end

  context 'with some tests erroring out' do
    before { @env[:files] = [File.join(File.dirname(__FILE__), 'dummy', 'error_test.rb')] }
    subject { @runner.call @env }

    it { should have(2).test_results }

    it "should have 1 passing test" do
      subject.select {|r| r.status == :passed}.should have(1).test_result
    end

    it "should have 1 errored test" do
      subject.select {|r| r.status == :error}.should have(1).test_result
    end
  end
end
