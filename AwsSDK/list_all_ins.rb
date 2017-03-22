require 'aws-sdk'

ec2 = Aws::EC2::Resource.new(region: 'eu-west-1')

# Get all instances with tag key 'Group'
# and tag value 'MyGroovyGroup':
ec2.instances.each do |i|
  puts 'ID:    ' + i.id
  puts 'State: ' + i.state.name
  i.tags.each do |t|
    puts "#{t.key}:#{t.value}"
  end
end

