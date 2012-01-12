require "minitest/pride"
require "minitest/unit"
require 'minitest/autorun'

require File.join(File.dirname(__FILE__), "../lib/log_parser")

class LogParserTest < MiniTest::Unit::TestCase
  def setup
    @sample = <<-SAMPLE
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
  end

  def subject
    @parsed = LogParser.parse(@sample)
  end

  def test_request_global_mean
    assert_equal 9345.239, subject[:global_mean]
  end

  def test_gets_request_min_response_time
    assert_equal 1234.1234, subject[:min]
  end

  def test_gets_request_max_response_time
    assert_equal 9999.9999, subject[:max]
  end

  def test_gets_finish_user_count
    assert_equal 563, subject[:finish_users_count]
  end

  def test_calculates_request_mean_standard_deviation
    assert_equal 33.48677721564408, subject[:standard_deviation]
  end

end
