require 'eventmachine'


$q = EM::Queue.new

EM.run do

  # EM.defer not works as expected
  EM.defer(proc do
    puts "Defer => #{Thread.current}"
    while true do
      processor = proc { |msg|
        puts msg
        $q.pop(&processor)
      }

      # pop off the first item  
      $q.pop(&processor)
    end    
  end)    
  
  puts "Main => #{Thread.current}"  

  100.times do |n|
    $q.push "#{n}"
    puts "push #{n}"
  end

  100.times do |n|
    puts "echo ..."
  end
  
  EM.stop
end
