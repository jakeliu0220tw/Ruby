require 'aws-sdk'

client = Aws::EC2::Client.new(
  access_key_id: AWS_ACCESS_ID,
  secret_access_key: AWS_SECRET_KEY,
  region: 'us-west-1'
)

ec2 = Aws::EC2::Resource.new({ client: client})
ins = ec2.instance('i-0bd469c8e24f423a0')

puts "ins = #{ins}"

if ins.exists?
  case ins.state.code
  when 48
    puts "#{ins.id} is terminated, you cannot stop it"
  when 64
    puts "#{ins.id} is stopping, it will be stopped in a bit"
  when 89
    puts "#{ins.id} is already stopped"
  else
    ins.stop
    puts "stop instance ..."
  end
end

