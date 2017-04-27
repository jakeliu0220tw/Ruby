require 'eventmachine'

EM.run do
  op = proc do
    puts "proc => op"
    2 + 2
  end
  
  callback = proc do |count|
    puts "proc => callback"
    puts "count is #{count}"
    EM.stop
  end
  
  EM.defer(op)
  
  EM.defer(op, callback)
  
end
