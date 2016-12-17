
qty = 5
dead = 0

qty.times do
  fork do
    puts "Child: process #{ Process.pid } started"
    sleep rand( 3 )
    puts "Child: process #{ Process.pid } done"
  end
end

# NOTE
# this, so the #puts inside signal handler isn't buffered
# otherwise it may cause a ThreadError if the handler is interrupted
# after calling #puts
$stdout.sync = true

trap( :CHLD ) do

  begin
    # while pid = Process.wait # by default this is blocking
    while pid = Process.wait( -1, Process::WNOHANG ) # non-blocking
      puts "Parent: #{ pid } exited"
      dead += 1
    end
  rescue Errno::ECHILD 
    puts "inside rescue clause"
    # this is if multiple signals are sent
    # while in this block
    # ergo signals not handled
  end

end

loop do
  exit if dead == qty
  print "."
  sleep 0.1
end
