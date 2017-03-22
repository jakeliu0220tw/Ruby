puts "ruby_proc2"

like_proc = Proc.new do |thing|
  puts "I like #{thing}."
end

hello_proc = proc { puts "hello world!" }

like_proc.call 'apple'
like_proc.call('banana')
hello_proc.call


