require 'aws-sdk'

ids = ['i-f1613ee9']

client = Aws::EC2::Client.new(
    access_key_id: 'ACCESS_KEY_ID',
    secret_access_key: 'SECRET_ACCESS_KEY',
    region: 'us-west-2'
)

resp = client.start_instances({
    dry_run: false,
    instance_ids: ids
})
# puts resp

resp.starting_instances.each do |i|
    puts "instance_id = #{i.instance_id}"
    puts "current_state.code = #{i.current_state.code}"
    puts "current_state.name = #{i.current_state.name}"
    puts "previous_state.code = #{i.previous_state.code}"
    puts "previous_state.name = #{i.previous_state.name}"
end
