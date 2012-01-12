require "minitest/pride"
require "minitest/unit"
require 'minitest/autorun'
require "tempfile"

require File.join(File.dirname(__FILE__), "../lib/tsung_log_parser")

class TsungLogParserTest <  MiniTest::Unit::TestCase
  class OutputSpy
    def output
      @output ||= []
    end

    def puts value
      output << value
    end
  end

  def test_writes_all_log_data
    file = Tempfile.new("tsung.log").path
    File.open(file, "w") do |file|
      file.write <<-LOG
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
                     "name" : "finish_users_count",
                     "total" : 430
                  }
               ]
            }
         ]
      }
      LOG
    end

    output = OutputSpy.new
    TsungLogParser.execute(output, file)
    output.output.must_include "Global Mean: 25634.239"
    output.output.must_include "Minimum Response Time: 5555.1234"
    output.output.must_include "Maximum Response Time: 9999.9999"
    output.output.must_include "Total User Count: 430"
  end
end
