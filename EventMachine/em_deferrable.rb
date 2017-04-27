require 'eventmachine'

class MyDeferrable
  include EM::Deferrable
  
  def run(str)
    puts "Go #{str}"
  end
end

EM.run do
  
  df = MyDeferrable.new  
  df.callback do |x|
    df.run(x)
    EM.stop
  end
  
  EM.add_timer(1) do
    df.set_deferred_status :succeeded, "Pikachu"
  end
  
end
