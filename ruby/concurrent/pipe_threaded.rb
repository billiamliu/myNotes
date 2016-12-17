require 'thread'

mutex = Mutex.new
condvar = ConditionVariable.new

reader, writer = IO.pipe

a = Thread.new do
  mutex.synchronize do
    writer.write "hello"
    condvar.wait mutex
    writer.close
    puts reader.read
  end
end

b = Thread.new do
  sleep 1

  mutex.synchronize do
    writer.write " world"
    condvar.signal
  end
end

[ a, b ].map( &:join )

require 'socket'

parent_socket, child_socket = Socket.pair( :UNIX, :DGRAM, 0 )

c = Thread.new do

  2.times do
    incoming = child_socket.recv 1000
    child_socket.send "Finished #{ incoming }", 0
  end

end

d = Thread.new do

  2.times do
    incoming = child_socket.recv 1000
    child_socket.send "Did not finish #{ incoming }", 0
  end

end

4.times do
  parent_socket.send "heavy lifting", 0
end

4.times do
  puts parent_socket.recv 1000
end

[ c, d ].map( &:join )
