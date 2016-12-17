require 'socket'

child_socket, parent_socket = Socket.pair( :UNIX, :DGRAM, 0 )

fork do
  parent_socket.close

  4.times do
    instruction = child_socket.recv 1000
    child_socket.send "#{ instruction } finished", 0
  end
  
end

child_socket.close

4.times do
  parent_socket.send "some lifting", 0
end


t = Thread.new do 

  begin
    while received = parent_socket.recv( 1000 ) do
      puts received
      sleep 0.5
    end
  rescue Errno::ECONNRESET
    puts "inside rescue"
  end

end

t.join
