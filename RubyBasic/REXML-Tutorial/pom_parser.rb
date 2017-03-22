require "rexml/document"
include REXML
string = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<project>
  <groupId>atgames.demo</groupId>
  <artifactId>HelloWorld</artifactId>
  <version>1.0.1</version>
  <dependencies>
    <dependency>
      <groupId>atgames.3rdparty</groupId>
      <artifactId>tinyxml</artifactId>
      <version>2_6_2</version>
      <type>zip</type>
    </dependency>
    <dependency>
      <groupId>atgames.3rdparty</groupId>
      <artifactId>curl</artifactId>
      <version>7_40_0</version>
      <type>zip</type>
    </dependency>    
  </dependencies>
</project>
EOF

doc = Document.new string

# Using XPath
groupId = XPath.first( doc, "//groupId" )
artifactId = XPath.first( doc, "//artifactId" )
version = XPath.first(doc, "//version")
puts groupId.text
puts artifactId.text 
puts version.text  

groupIds = XPath.match( doc, "//dependencies//dependency//groupId" ) 
artifactIds = XPath.match( doc, "//dependencies//dependency//artifactId" )
versions = XPath.match( doc, "//dependencies//dependency//version" )
puts groupIds
puts artifactIds
puts versions
size = groupIds.size
puts size
puts groupIds.first
puts groupIds.first.text

puts "---------------------"
while groupIds.size > 0 
  a = groupIds.pop
  b = artifactIds.pop
  c = versions.pop
  puts "#{a.text}-#{b.text}-#{c.text}"  
end
  

puts "----------------------"
groupId = XPath.first( doc, "//groupId" )
artifactId = XPath.first( doc, "//artifactId" )
version = XPath.first(doc, "//version")
puts groupId.text
puts artifactId.text 
puts version.text  

#version << Text.new("test")
version.text = "test"
all_children = doc.to_a
#puts all_children

File.open("D:\\GitRepo\\AtGamesCloud\\HelloWorld\\test.xml", "w+") do |f|
  doc.write(f)
end

#myfile = File.open('D:\\GitRepo\\AtGamesCloud\\HelloWorld\\test.xml')
#doc.write(myfile)
#myfile.close
