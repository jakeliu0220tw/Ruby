require 'eventmachine'
require 'thread'

class MyConnection < EM::Connection
  def initialize
    puts "initialize"
  end  

  def post_init
    puts "post_init"
  end

  def receive_data data
    puts "receive_data"
    fail "error in receive_data"
  end

  def unbind
    puts "unbind"
  end
end

EM.error_handler { |e|
  puts "Error raised during event loop: #{e.message}, EM running? => #{EM.reactor_running?}"
}

puts "EM running? => #{EM.reactor_running?}"
EM.run do

  EventMachine.add_periodic_timer(1) { 
    puts "... EM running? => #{EM.reactor_running?} ..."
  }

  EventMachine::start_server('0.0.0.0', 8800, MyConnection)
end
