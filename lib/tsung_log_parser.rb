class TsungLogParser
  def self.execute output, tsung_log, tsung_dump
    parsed_log = LogParser.parse(File.read tsung_log)
    output.puts "Global Mean: #{parsed_log[:global_mean]}"
    output.puts "Minimum Response Time: #{parsed_log[:min]}"
    output.puts "Maximum Response Time: #{parsed_log[:max]}"
    output.puts "Total User Count: #{parsed_log[:finish_users_count]}"
    parsed_dump = DumpParser.parse(File.read tsung_dump)
    output.puts "Internal Server Errors (500's) : #{parsed_dump[:internal_server_errors]}"
    p parsed_log
  end
end
