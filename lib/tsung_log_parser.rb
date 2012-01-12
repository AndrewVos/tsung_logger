class TsungLogParser
  def self.execute output, tsung_log
    parsed_log = LogParser.parse(File.read tsung_log)
    output.puts "Global Mean: #{parsed_log[:global_mean]}"
    output.puts "Minimum Response Time: #{parsed_log[:min]}"
    output.puts "Maximum Response Time: #{parsed_log[:max]}"
    output.puts "Total User Count: #{parsed_log[:finish_users_count]}"
  end
end
