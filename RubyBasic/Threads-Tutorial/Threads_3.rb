words = ["hello", "world", "goodbye", "mars"]
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

puts "== before running threads"
wordsthread = Thread.new { words.each { |word| puts word } }
numbersthread = Thread.new { numbers.each { |number| puts number } }

[wordsthread, numbersthread].each do |t|
  t.join
end  
puts "== end running threads"
