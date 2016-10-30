require 'socket'
require_relative 'rock_paper_scissors'

s = TCPServer.new 3000
threads = []

2.times do |n|
  i = n + 1
  conn = s.accept

  threads << Thread.new( conn ) do |c|
    Thread.current[ :number ] = i
    Thread.current[ :player ] = c
    c.puts "Welcome, player #{ i }"
    c.print "Your move, rock, paper, or scissors? "
    Thread.current[ :move ] = c.gets.chomp.downcase
    c.puts "Waiting for the other player to make a move"
  end

end

a, b = threads
a.join
b.join

rps1, rps2 = [ a, b ].map { |player| Games::RPS.new player[ :move ] }
winner = rps1.play rps2

if winner
  result = winner.move
else
  result = "TIE"
end

threads.each { |t| t[ :player ].puts "The winner is #{ result }!" }

