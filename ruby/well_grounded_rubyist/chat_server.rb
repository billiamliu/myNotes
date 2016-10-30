require 'socket'

def welcome chatter
  chatter.puts "TYPE 'exit' to leave"
  chatter.print "Hello, please enter your name: "
  chatter.readline.chomp
end

def broadcaster chatters
  lambda { |msg| chatters.each { |c| c.puts msg } }
end

s = TCPServer.new 3000
chatters = []
broadcast = broadcaster chatters

while chatter = s.accept
  Thread.new chatter do |c|

    name = welcome chatter
    broadcast.( "#{ name } has joined" )
    chatters << c
    $stdout.puts "#{ name } joined, currently #{ chatters.length } #{ chatters.length > 1 ? 'chatters' : 'chatter'}"

    begin
      loop do
        line = c.readline.chomp
        raise EOFError if line === 'exit'
        payload = "#{ name }: #{ line }#{ $/ }" 
        broadcast.( payload ) 
        $stdout.puts payload
      end
    rescue EOFError
      c.close
      chatters.delete c
      payload = "#{ name } has left." 
      broadcast.( payload )
      $stdout.puts payload
    end

  end
end
