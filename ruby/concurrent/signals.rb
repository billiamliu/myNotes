puts Process.pid

trap( :INT ) { puts "can't touch this" }
sleep
