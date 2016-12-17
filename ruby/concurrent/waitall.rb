
qty = 7

qty.times do
  fork do
    sleep rand( 3 )
    puts "child process #{ Process.pid } ran"
  end
end

# doesn't take arguments, is blocking
# compare to while loop and Process.wait( -1, Process::WNOHANG )
Process.waitall
