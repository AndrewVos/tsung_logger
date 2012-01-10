require "rubygems"
require "json"

require "minitest/pride"
require "minitest/unit"
require 'minitest/autorun'

class TestLogParser < MiniTest::Unit::TestCase
  def setup
    sample = <<-SAMPLE
    {
       "stats" : [
          {
             "samples" : [
                {
                   "name" : "request",
                   "global_mean" : 25634.239,
                   "min" : 5555.1234,
                   "max" : 9999.9999 
                },
                {
                   "name" : "request",
                   "global_mean" : 23423.239,
                   "min" : 1234.1234,
                   "max" : 6666.6666
                }
             ]
          },
          {
             "samples" : [
                {
                   "name" : "request",
                   "global_mean" : 9345.239,
                   "min" : 4321.4321,
                   "max" : 8888.8888
                }
             ]
          }
       ]
    }
    SAMPLE
    @parsed = LogParser.parse(sample)
  end

  def test_request_global_mean
    assert_equal 9345.239, @parsed[:global_mean]
  end

  def test_gets_request_min_response_time
    assert_equal 1234.1234, @parsed[:min]
  end

  def test_gets_request_max_response_time
    assert_equal 9999.9999, @parsed[:max]
  end
end

class LogParser
  def self.parse(json_sample)
    json = JSON.parse(json_sample)

    request_samples = json["stats"].map do |stat|
      stat["samples"]
    end.flatten
    
    p request_samples

    {
      :global_mean => request_samples.last["global_mean"],
      :min         => request_samples.map {|s| s["min"]}.min,
      :max         => request_samples.map {|s| s["max"]}.max
    }
  end
end
