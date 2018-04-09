require 'eventmachine'
require 'thread'

class MyConnection < EM::Connection
  def initialize
    @buf ||= ''
    puts "initialize"
  end  

  def post_init
    puts "post_init"
  end

  def receive_data data
    puts "receive_data"
    @buf << data
    if line = @buf.slice(/\r?\n/)
      puts "You said: #{@buf}"
      @buf = ''
    end
  end

  def unbind
    puts "unbind"
  end
end

EM.error_handler { |e|
  puts "Error raised during event loop: #{e.message}, EM running? => #{EM.reactor_running?}"
}

EM.run do
  EventMachine::start_server('0.0.0.0', 8800, MyConnection)
end
