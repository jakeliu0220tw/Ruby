puts "ruby_proc.rb"

# proc => short of procedure

def my_func my_proc
  puts "start my_func"
  my_proc.call
  puts "end my_func"
end

my_proc = proc {
  puts "hello"
}

my_func my_proc





