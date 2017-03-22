# limit thread number
thread_limit = 4

threads = []
things_to_process.each do |thing|
  while (threads.map { |t| t.status }.count('run') + threads.map { |t| t.status }.count('sleep')) >= thread_limit do 
    sleep 5 
  end
  threads << Thread.new { the_task(thing) }
end
output = threads.map { |t| t.value }  
