require 'eventmachine'

EM.run do
  puts "EM.run => #{Thread.current}"
  
  s = EM.spawn do |val|
    puts "EM.spawn => #{Thread.current}"
    puts "Received #{val}"
  end

  EM.add_periodic_timer(1) do
    puts "EM.add_periodic_timer => #{Thread.current}"
    s.notify "hello"
  end

  EM.add_periodic_timer(1) do
    #puts "Periodic"
  end

  EM.add_timer(10) do
    puts "EM.add_timer => #{Thread.current}"
    EM.stop
  end
  
end

