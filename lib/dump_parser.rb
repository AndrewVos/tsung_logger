class DumpParser
  def self.parse(sample)
    {
      :internal_server_errors =>  sample.scan(/Recv:.*HTTP\/\d\.\d 500 Internal Server Error/).size
    }
  end
end
