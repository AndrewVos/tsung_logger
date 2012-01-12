require "rubygems"
require "json"
require "ruby-standard-deviation"

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

