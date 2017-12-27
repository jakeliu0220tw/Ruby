require 'aws-sdk'

ips = ['52.192.179.145']
ids = ['i-0853159c5f128d042']

client = Aws::EC2::Client.new(
    access_key_id: 'AWS_ACCESS_ID',
    secret_access_key: 'AWS_ACCESS_KEY',
    region: 'ap-northeast-1'
)

# resp = client.describe_addresses({
# 	public_ips: ips,
# 	dry_run: false
# })

# puts resp

# resp.addresses.each do |e|
#   puts e.instance_id
#   puts e.public_ip
# end

resp = client.describe_addresses({
  filters: [
    { name: 'instance-id', values: ids }
  ],
  dry_run: false
})

puts resp

resp.addresses.each do |e|
  puts e.instance_id
  puts e.public_ip
end
