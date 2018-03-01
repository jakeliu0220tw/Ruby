require 'aws-sdk'

client = Aws::EC2::Client.new(
  access_key_id: 'ACCESS_KEY_ID',
  secret_access_key: 'SECRET_ACCESS_KEY',
  region: 'us-west-2'
)

resp = client.describe_instances({
  filters: [
    { name: "instance-type", values: ["g2.2xlarge"] },
    { name: "instance-state-name", values: ["pending", "running", "shutting-down", "stopping "] }
  ],
  max_results: 1000
})

puts "num of running g2.2xlarge => #{resp.reservations.size}"
resp.reservations.each do |e|
  puts "instance_id => #{e.instances[0].instance_id}"
end
