require 'yaml'

helloworld = "hello world".to_yaml
puts helloworld

class MyClass 
  def initialize( anInt, aString ) 
    @myint = anInt 
    @mystring =aString 
  end 
end

# object to yml 
obj = MyClass.new(100, 'helloworld')
puts obj.to_yaml

# YAML.dump(obj)
arr = ['fred', 'bert', 'mary', ['aaa', 'bbb']]
yml_arr = YAML.dump(arr)
puts yml_arr

#File.open('friends.yml', 'w') do |f|
#  f.write(yml_arr)
#end
File.open('myfriends.yml', 'w') do |f|
  YAML.dump(['alan', 'bob', 'cindy'], f)
end

File.open('mycats.yml', 'w') do |f|
  YAML.dump({'mycats' => ['catOrange', 'catMix', 'catTiger']}, f)
end

# YAML.load(file handler)
File.open('myfriends.yml', 'r') do |f|
  friend_ary = YAML.load(f)
  puts friend_ary
end

# yaml dump hash
File.open('hash.yml','w') do |f|
  YAML.dump({'name' => 'jake', 'age' => '35'}, f)
end
File.open('hash.yml','a') do |f|
  YAML.dump({'name' => 'cindy', 'age' => '36'}, f)
end

# load_documents(file handler)
new_ary = []
File.open('hash.yml','r') do |f|
  YAML.load_documents(f) do |doc|
    new_ary << doc
  end
end
new_ary.each { |e| puts e }

puts eval("1+2")
  