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

  def setup
    @log_file = Tempfile.new("tsung.log").path
    @dump_file = Tempfile.new("tsung.dump").path

    File.open(@log_file, "w") do |file|
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

    File.open(@dump_file, "w") do |file|
      file.write <<-DUMP
        Recv:1326372146.48497:<0.104.0>:HTTP/1.1 500 Internal Server Error
        X-Frame-Options: sameorigin

        Recv:1326372146.48497:<0.104.0>:HTTP/1.1 500 Internal Server Error
        X-Frame-Options: sameorigin
      DUMP
    end
  end

  def test_writes_all_log_data
    output = OutputSpy.new
    TsungLogParser.execute(output, @log_file, @dump_file)
    output.output.must_include "Global Mean: 25634.239"
    output.output.must_include "Minimum Response Time: 5555.1234"
    output.output.must_include "Maximum Response Time: 9999.9999"
    output.output.must_include "Total User Count: 430"
  end

  def test_writes_dump_data
    output = OutputSpy.new
    TsungLogParser.execute(output, @log_file, @dump_file)
    output.output.must_include "Internal Server Errors (500's) : 2"
  end
end
