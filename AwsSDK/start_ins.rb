require 'aws-sdk'

#ec2 = Aws::EC2::Resource.new(region: 'us-west-2')
#ins = ec2.instance('i-f1613ee9')

ec2 = Aws::EC2::Resource.new(region: 'eu-west-1')
ins = ec2.instance('i-0bd469c8e24f423a0')
    
if ins.exists?
  case ins.state.code
  when 0  
    puts "#{ins.id} is pending, so it will be running in a bit"
  when 16 
    puts "#{ins.id} is already started"
  when 48 
    puts "#{ins.id} is terminated, so you cannot start it"
  else
    ins.start
    puts "start instance ..."
  end
end

