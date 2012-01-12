require "minitest/pride"
require "minitest/unit"
require 'minitest/autorun'

require File.join(File.dirname(__FILE__), "../lib/dump_parser")

class DumpParserTest < MiniTest::Unit::TestCase
  def setup
    @sample = <<-SAMPLE
      Recv:1326372146.48497:<0.104.0>:HTTP/1.1 500 Internal Server Error
      X-Frame-Options: sameorigin

      Recv:1326372146.48497:<0.104.0>:HTTP/1.1 500 Internal Server Error
      X-Frame-Options: sameorigin
    SAMPLE
  end

  def subject
    DumpParser.parse(@sample)
  end

  def test_count_server_errors
    assert_equal 2, subject[:internal_server_errors]
  end
end
