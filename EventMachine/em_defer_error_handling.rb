require 'eventmachine'
require 'thread'

EM.run do
  EM.add_timer(5) do
    puts "Main #{Thread.current}"
    EM.stop_event_loop
  end
  
  EM.defer(proc do
    begin
      puts "Defer #{Thread.current}"
      sleep(1)
      puts "after Defer sleep 1 sec"
      fail "defer error"
    rescue Exception => ex
      puts "an error of type #{ex.class} happened, message is #{ex.message}"
    end
  end)

end
