require 'aws-sdk'

client = Aws::EC2::Client.new(
  access_key_id: AWS_ACCESS_ID,
  secret_access_key: AWS_SECRET_KEY,
  region: 'us-west-1'
)

ec2 = Aws::EC2::Resource.new({ client: client})

# Get all instances with tag key 'Group'
# and tag value 'MyGroovyGroup':
ec2.instances.each do |i|
  puts 'ID:    ' + i.id
  puts 'State: ' + i.state.name
  i.tags.each do |t|
    puts "#{t.key}:#{t.value}"
  end
end

