# http://www.rubydoc.info/github/eventmachine/eventmachine/EventMachine/Channel

require 'eventmachine'


#channel = EventMachine::Channel.new
#sid     = channel.subscribe { |msg| p [:got, msg] }
#
#channel.push('hello world')
##channel.unsubscribe(sid)


channel = EventMachine::Channel.new

the = Thread.new {
  EM.run do
    puts "EM.run"
    sid     = channel.subscribe { |msg| puts "got: #{msg}" }
    #channel.unsubscribe(sid)
    puts "after subscribe"
  end
}

while not EM.reactor_running?
  puts "EM not running"
end

channel.push('hello world')
(1..10).each do |n|
  channel.push(n)
end
  
the.join
