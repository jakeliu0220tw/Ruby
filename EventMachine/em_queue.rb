require 'eventmachine'
 
q = EM::Queue.new

EM.run do
  q.push('one', 'two', 'three')
  
  3.times do
    q.pop { |msg| puts msg}
  end

  EM.stop  
end
