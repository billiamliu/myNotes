require 'socket'

s = TCPServer.new 3000

while conn = s.accept

  Thread.new( conn ) do |c|
    begin
      c.puts "hello socket client #{ c }"
      c.puts "enter any message to exit"
      c.readline.chomp
    rescue EOFError
      $stdout.puts "There was an error with #{ c }, closing connection"
      c.close
    ensure
      c.close
    end
  end

end
