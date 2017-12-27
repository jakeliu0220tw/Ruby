require 'aws-sdk'

client = Aws::EC2::Client.new(
  access_key_id: AWS_ACCESS_ID,
  secret_access_key: AWS_SECRET_KEY,
  region: 'us-west-1'
)

ec2 = Aws::EC2::Resource.new({ client: client})
ins = ec2.instance('i-0d6119e2880adfacd')

puts "ins = #{ins}"

if ins.exists?
  puts "State: #{ins.state.name}"
end

l