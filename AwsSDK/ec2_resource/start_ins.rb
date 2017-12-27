require 'aws-sdk'

client = Aws::EC2::Client.new(
  access_key_id: AWS_ACCESS_ID,
  secret_access_key: AWS_SECRET_KEY,
  region: 'us-west-1'
)

ec2 = Aws::EC2::Resource.new({ client: client})
ins = ec2.instance('i-0e439b69c0b932bbe')

    
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

