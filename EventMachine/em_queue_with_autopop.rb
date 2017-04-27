require 'eventmachine'


q = EM::Queue.new

EM.run do
  
  processor = proc { |msg|
    puts msg
    q.pop(&processor)
  }

  # pop off the first item  
  q.pop(&processor)  
  
  q.push "1", "2", "3"
  puts "push 1,2,3"
  sleep 1
  
  q.push "4", "5", "6"
  puts "push 4,5,6"
  sleep 1
  
  q.push "7", "8", "9"
  puts "push 7,8,9"  
  sleep 1
      
  EM.stop  
end
