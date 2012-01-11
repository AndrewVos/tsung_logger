require "rubygems"
require "json"
require "ruby-standard-deviation"
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
                   "max" : 9999.9999,
                   "mean" : 63.344
                },
                {
                   "name" : "request",
                   "global_mean" : 23423.239,
                   "min" : 1234.1234,
                   "max" : 6666.6666,
                   "mean" : 12.23445
                },
                {
                   "name" : "finish_users_count",
                   "total" : 430
                }
             ]
          },
          {
             "samples" : [
                {
                   "name" : "request",
                   "global_mean" : 9345.239,
                   "min" : 4321.4321,
                   "max" : 8888.8888,
                   "mean" : 93.35
                },
                {
                   "name" : "finish_users_count",
                   "total" : 563
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

  def test_gets_finish_user_count
    assert_equal 563, @parsed[:finish_users_count]
  end

  def test_calculates_request_mean_standard_deviation
    assert_equal 33.48677721564408, @parsed[:standard_deviation]
  end
end

class LogParser
  def self.parse(json_sample)
    json = JSON.parse(json_sample)

    request_samples = json["stats"].map do |stat|
      stat["samples"].select { |r| r["name"]=="request"}
    end.flatten

    last_sample = json["stats"].last["samples"]

    {
      :global_mean        => request_samples.last["global_mean"],
      :min                => request_samples.map {|s| s["min"]}.min,
      :max                => request_samples.map {|s| s["max"]}.max,
      :finish_users_count => last_sample.find { |f| f["name"]=="finish_users_count" }["total"],
      :standard_deviation => request_samples.map {|s| s["mean"]}.standard_deviation
    }
  end

  
end
