require 'rspec'
require 'minitest/unit'
require 'testify'
require_relative '../lib/minitest_adaptor'

RSpec.configure do |config|
end

RSpec::Matchers.define :all_be do |expected|
  match do |actual|
    actual.all? { |i| i == expected }
  end

  failure_message_for_should do |actual|
    "expected that all elements of #{actual} would be #{expected}"
  end
end
