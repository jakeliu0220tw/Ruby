require 'aws-sdk'

ids = ['i-f1613ee9']

client = Aws::EC2::Client.new(
    access_key_id: 'ACCESS_KEY_ID',
    secret_access_key: 'SECRET_ACCESS_KEY',
    region: 'us-west-2'
)

resp = client.describe_instance_status({
  dry_run: false,
  instance_ids: ids,
  include_all_instances: true,
})
# puts resp

resp.instance_statuses.each do |i|
    puts "instance_id = #{i.instance_id}"
    puts "availability_zone = #{i.availability_zone}" #=> String
    i.events.each do |j| #=> Array
        puts j.code
        puts j.description
        puts j.not_before
        puts j.not_after
    end
    puts "instance_state.code = #{i.instance_state.code}" #=> Integer
    puts "instance_state.name = #{i.instance_state.name}" #=> String, one of "pending", "running", "shutting-down", "terminated", "stopping", "stopped"
    i.system_status.details.each do |j| #=> Array
        puts "system_status.details.name = #{j.name}"
        puts "system_status.details.status = #{j.status}"
        puts "system_status.details.impaired_since = #{j.impaired_since}"
    end
    puts "instance_status.status = #{i.instance_status.status}" #=> String, one of "ok", "impaired", "insufficient-data", "not-applicable", "initializing"
    i.instance_status.details.each do |j| #=> Array
        puts "instance_status.details.name = #{j.name}"
        puts "instance_status.details.status = #{j.status}"
        puts "instance_status.details.impaired_since = #{j.impaired_since}"
    end
    puts i.next_token #=> String
end
