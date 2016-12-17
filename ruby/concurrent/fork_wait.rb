saga = fork do
  sleep 4
  exit 123
end

3.times do
  fork do
    puts "child process #{ Process.pid }"
    if rand( 3 ).even?
      sleep 1
      exit 111
    else
      sleep 2
      exit 112
    end
  end
end

3.times do
  # puts "child processes complete #{ Process.wait }"
  pid, status = Process.wait2
  puts "Process #{ pid } exited with #{ status }"
end

pid, status = Process.waitpid2 saga # returns [ pid, Process::Status object ]
puts "Saga #{ pid } exited with #{ status }"
