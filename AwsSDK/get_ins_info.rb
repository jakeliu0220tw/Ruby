require 'aws-sdk'

#ec2 = Aws::EC2::Resource.new(region: 'us-west-2')
#ins = ec2.instance('i-f1613ee9')

ec2 = Aws::EC2::Resource.new(region: 'us-west-1')
ins = ec2.instance('i-0d6119e2880adfacd')

puts "ins = #{ins}"

if ins.exists?
  puts "State: #{ins.state.name}"
end

