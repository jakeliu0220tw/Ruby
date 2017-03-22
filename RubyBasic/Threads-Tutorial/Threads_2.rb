puts Thread.main.inspect # run
puts Thread.new{}.kill.inspect # dead
puts Thread.new{}.inspect # sleep

thread1 = Thread.new{}
puts thread1.status # false
thread2 = Thread.new{fail "test!"}
puts thread2.status # nil


