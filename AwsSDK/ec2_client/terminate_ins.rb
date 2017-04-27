require 'aws-sdk'

ids = ['i-08fbc0e527d903e28']

client = Aws::EC2::Client.new(
    access_key_id: 'ACCESS_KEY_ID',
    secret_access_key: 'SECRET_ACCESS_KEY',
    region: 'us-west-2'
)

resp = client.terminate_instances({
  dry_run: false,
  instance_ids: ids, # required
})

puts resp

resp.terminating_instances.each do |i| #=> Array
    puts "i.instance_id = #{i.instance_id}" #=> String
    puts "i.current_state.code = #{i.current_state.code}" #=> Integer
    puts "i.current_state.name = #{i.current_state.name}" #=> String, one of "pending", "running", "shutting-down", "terminated", "stopping", "stopped"
    puts "i.previous_state.code = #{i.previous_state.code}" #=> Integer
    puts "i.previous_state.name = #{i.previous_state.name}" #=> String, one of "pending", "running", "shutting-down", "terminated", "stopping", "stopped"
end
