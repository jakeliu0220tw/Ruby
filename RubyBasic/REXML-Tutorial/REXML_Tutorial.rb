require "rexml/document"
include REXML
string = <<EOF
<inventory title="OmniCorp Store #45x10^3">
  <section name="health">
    <item upc="123456789" stock="12">
      <name>Invisibility Cream</name>
      <price>14.50</price>
      <description>Makes you invisible</description>
    </item>
    <item upc="445322344" stock="18">
      <name>Levitation Salve</name>
      <price>23.99</price>
      <description>Levitate yourself for up to 3 hours per application</description>
    </item>
  </section>
  <section name="food">
    <item upc="485672034" stock="653">
      <name>Blork and Freen Instameal</name>
      <price>4.95</price>
      <description>A tasty meal in a tablet; just add water</description>
    </item>
    <item upc="132957764" stock="44">
      <name>Grob winglets</name>
      <price>3.56</price>
      <description>Tender winglets of Grob. Just add water</description>
    </item>
  </section>
</inventory>
EOF

# Accessing Elements
doc = Document.new string
doc.elements.each("inventory/section") { |element| puts element.attributes["name"] }
# -> health
# -> food
doc.elements.each("*/section/item") { |element| puts element.attributes["upc"] }
# -> 123456789
# -> 445322344
# -> 485672034
# -> 132957764
root = doc.root
puts root.attributes["title"]
# -> OmniCorp Store #45x10^3
puts root.elements["section/item[@stock='44']"].attributes["upc"]
# -> 132957764
puts root.elements["section"].attributes["name"]
# -> health (returns the first encountered matching element
puts root.elements[1].attributes["name"]  
# -> health (returns the FIRST child element)   
root.detect {|node| node.kind_of? Element and node.attributes["name"] == "food" }  
  
# Using XPath
# The invisibility cream is the first <item>
invisibility = XPath.first( doc, "//item" ) 
# Prints out all of the prices
XPath.each( doc, "//price") { |element| puts element.text }
# Gets an array of all of the "name" elements in the document.
names = XPath.match( doc, "//name" )   
puts names  
  

# Using to_a()
all_elements = doc.elements.to_a
all_children = doc.to_a
all_upc_strings = doc.elements.to_a( "//item/attribute::upc" )
all_name_elements = doc.elements.to_a( "//name" )
puts all_elements
#puts all_name_elements  
    