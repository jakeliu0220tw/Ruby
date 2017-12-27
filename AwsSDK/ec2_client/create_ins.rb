require 'aws-sdk'

client = Aws::EC2::Client.new(
    access_key_id: 'ACCESS_KEY_ID',
    secret_access_key: 'SECRET_ACCESS_KEY',
    region: 'us-west-2'
)

# resp = client.run_instances({
#   dry_run: false,
#   image_id: "String", # required
#   min_count: 1, # required
#   max_count: 1, # required
#   key_name: "String",
#   security_groups: ["String"],
#   security_group_ids: ["String"],
#   user_data: "String",
#   instance_type: "t1.micro", # accepts t1.micro, t2.nano, t2.micro, t2.small, t2.medium, t2.large, t2.xlarge, t2.2xlarge, m1.small, m1.medium, m1.large, m1.xlarge, m3.medium, m3.large, m3.xlarge, m3.2xlarge, m4.large, m4.xlarge, m4.2xlarge, m4.4xlarge, m4.10xlarge, m4.16xlarge, m2.xlarge, m2.2xlarge, m2.4xlarge, cr1.8xlarge, r3.large, r3.xlarge, r3.2xlarge, r3.4xlarge, r3.8xlarge, r4.large, r4.xlarge, r4.2xlarge, r4.4xlarge, r4.8xlarge, r4.16xlarge, x1.16xlarge, x1.32xlarge, i2.xlarge, i2.2xlarge, i2.4xlarge, i2.8xlarge, i3.large, i3.xlarge, i3.2xlarge, i3.4xlarge, i3.8xlarge, i3.16xlarge, hi1.4xlarge, hs1.8xlarge, c1.medium, c1.xlarge, c3.large, c3.xlarge, c3.2xlarge, c3.4xlarge, c3.8xlarge, c4.large, c4.xlarge, c4.2xlarge, c4.4xlarge, c4.8xlarge, cc1.4xlarge, cc2.8xlarge, g2.2xlarge, g2.8xlarge, cg1.4xlarge, p2.xlarge, p2.8xlarge, p2.16xlarge, d2.xlarge, d2.2xlarge, d2.4xlarge, d2.8xlarge, f1.2xlarge, f1.16xlarge
#   placement: {
#     availability_zone: "String",
#     group_name: "String",
#     tenancy: "default", # accepts default, dedicated, host
#     host_id: "String",
#     affinity: "String",
#   },
#   kernel_id: "String",
#   ramdisk_id: "String",
#   block_device_mappings: [
#     {
#       virtual_name: "String",
#       device_name: "String",
#       ebs: {
#         snapshot_id: "String",
#         volume_size: 1,
#         delete_on_termination: false,
#         volume_type: "standard", # accepts standard, io1, gp2, sc1, st1
#         iops: 1,
#         encrypted: false,
#       },
#       no_device: "String",
#     },
#   ],
#   monitoring: {
#     enabled: false, # required
#   },
#   subnet_id: "String",
#   disable_api_termination: false,
#   instance_initiated_shutdown_behavior: "stop", # accepts stop, terminate
#   private_ip_address: "String",
#   ipv_6_addresses: [
#     {
#       ipv_6_address: "String",
#     },
#   ],
#   ipv_6_address_count: 1,
#   client_token: "String",
#   additional_info: "String",
#   network_interfaces: [
#     {
#       network_interface_id: "String",
#       device_index: 1,
#       subnet_id: "String",
#       description: "String",
#       private_ip_address: "String",
#       groups: ["String"],
#       delete_on_termination: false,
#       private_ip_addresses: [
#         {
#           private_ip_address: "String", # required
#           primary: false,
#         },
#       ],
#       secondary_private_ip_address_count: 1,
#       associate_public_ip_address: false,
#       ipv_6_addresses: [
#         {
#           ipv_6_address: "String",
#         },
#       ],
#       ipv_6_address_count: 1,
#     },
#   ],
#   iam_instance_profile: {
#     arn: "String",
#     name: "String",
#   },
#   ebs_optimized: false,
#   tag_specifications: [
#     {
#       resource_type: "customer-gateway", # accepts customer-gateway, dhcp-options, image, instance, internet-gateway, network-acl, network-interface, reserved-instances, route-table, snapshot, spot-instances-request, subnet, security-group, volume, vpc, vpn-connection, vpn-gateway
#       tags: [
#         {
#           key: "String",
#           value: "String",
#         },
#       ],
#     },
#   ],
# })

resp = client.run_instances({
  dry_run: false,
  image_id: "ami-746aba14", # required
  min_count: 1, # required
  max_count: 1, # required
  key_name: "Zuma_20160908",
  instance_type: "t2.micro",
  monitoring: {
    enabled: false, # required
  },
  disable_api_termination: false,
  instance_initiated_shutdown_behavior: "stop", # accepts stop, terminate
  network_interfaces: [
    {
      device_index: 0,
      subnet_id: "subnet-a42fa8fc",
      groups: ["sg-197c8360"],
      delete_on_termination: true,
      associate_public_ip_address: true
    },
  ]
})

puts "reservation_id = #{resp.reservation_id}" #=> String
puts "owner_id = #{resp.owner_id}" #=> String
puts "requester_id = #{resp.requester_id}"  #=> String
resp.groups.each do |g| #=> Array
    puts "group_name = #{g.group_name}" #=> String
    puts "group_id = #{g.group_id}" #=> String
end
resp.instances.each do |i| #=> Array
    puts "instance_id = #{i.instance_id}" #=> String
    puts "image_id = #{i.image_id}" #=> String
    puts "state.code = #{i.state.code}" #=> Integer
    puts "state.name = #{i.state.name}" #=> String, one of "pending", "running", "shutting-down", "terminated", "stopping", "stopped"
    puts "private_dns_name = #{i.private_dns_name}" #=> String
    puts "public_dns_name = #{i.public_dns_name}" #=> String
    puts "state_transition_reason = #{i.state_transition_reason}" #=> String
    puts "key_name = #{i.key_name}" #=> String
    puts "ami_launch_index = #{i.ami_launch_index}" #=> Integer
    i.product_codes.each do |c| #=> Array
        puts "product_code_id = #{c.product_code_id}" #=> String
        puts "product_code_type = #{c.product_code_type}" #=> String, one of "devpay", "marketplace"
    end
    puts "instance_type = #{i.instance_type}" #=> String, one of "t1.micro", "t2.nano", "t2.micro", "t2.small", "t2.medium", "t2.large", "t2.xlarge", "t2.2xlarge", "m1.small", "m1.medium", "m1.large", "m1.xlarge", "m3.medium", "m3.large", "m3.xlarge", "m3.2xlarge", "m4.large", "m4.xlarge", "m4.2xlarge", "m4.4xlarge", "m4.10xlarge", "m4.16xlarge", "m2.xlarge", "m2.2xlarge", "m2.4xlarge", "cr1.8xlarge", "r3.large", "r3.xlarge", "r3.2xlarge", "r3.4xlarge", "r3.8xlarge", "r4.large", "r4.xlarge", "r4.2xlarge", "r4.4xlarge", "r4.8xlarge", "r4.16xlarge", "x1.16xlarge", "x1.32xlarge", "i2.xlarge", "i2.2xlarge", "i2.4xlarge", "i2.8xlarge", "i3.large", "i3.xlarge", "i3.2xlarge", "i3.4xlarge", "i3.8xlarge", "i3.16xlarge", "hi1.4xlarge", "hs1.8xlarge", "c1.medium", "c1.xlarge", "c3.large", "c3.xlarge", "c3.2xlarge", "c3.4xlarge", "c3.8xlarge", "c4.large", "c4.xlarge", "c4.2xlarge", "c4.4xlarge", "c4.8xlarge", "cc1.4xlarge", "cc2.8xlarge", "g2.2xlarge", "g2.8xlarge", "cg1.4xlarge", "p2.xlarge", "p2.8xlarge", "p2.16xlarge", "d2.xlarge", "d2.2xlarge", "d2.4xlarge", "d2.8xlarge", "f1.2xlarge", "f1.16xlarge"
    puts "launch_time = #{i.launch_time}" #=> Time
    puts "placement.availability_zone = #{i.placement.availability_zone}" #=> String
    puts "placement.group_name = #{i.placement.group_name}" #=> String
    puts "placement.tenancy = #{i.placement.tenancy}" #=> String, one of "default", "dedicated", "host"
    puts "placement.host_id = #{i.placement.host_id}" #=> String
    puts "placement.affinity = #{i.placement.affinity}" #=> String
    puts "kernel_id = #{i.kernel_id}" #=> String
    puts "ramdisk_id = #{i.ramdisk_id}" #=> String
    puts "platform = #{i.platform}" #=> String, one of "Windows"
    puts "monitoring.state = #{i.monitoring.state}" #=> String, one of "disabled", "disabling", "enabled", "pending"
    puts "subnet_id = #{i.subnet_id}" #=> String
    puts "vpc_id = #{i.vpc_id}" #=> String
    puts "private_ip_address = #{i.private_ip_address}" #=> String
    puts "public_ip_address = #{i.public_ip_address}" #=> String
    puts "state_reason.code = #{i.state_reason.code}" #=> String
    puts "state_reason.message = #{i.state_reason.message}" #=> String
    puts "architecture = #{i.architecture}" #=> String, one of "i386", "x86_64"
    puts "root_device_type = #{i.root_device_type}" #=> String, one of "ebs", "instance-store"
    puts "root_device_name = #{i.root_device_name}" #=> String
    i.block_device_mappings.each do |d| #=> Array
        puts "device_name = #{d.device_name}" #=> String
        puts "ebs.volume_id = #{d.ebs.volume_id}" #=> String
        puts "ebs.status = #{d.ebs.status}" #=> String, one of "attaching", "attached", "detaching", "detached"
        puts "ebs.attach_time = #{d.ebs.attach_time}" #=> Time
        puts "ebs.delete_on_termination = #{d.ebs.delete_on_termination}" #=> true/false
    end

    puts "virtualization_type = #{i.virtualization_type}" #=> String, one of "hvm", "paravirtual"
    puts "instance_lifecycle = #{i.instance_lifecycle}" #=> String, one of "spot", "scheduled"
    puts "spot_instance_request_id = #{i.spot_instance_request_id}" #=> String
    puts "client_token = #{i.client_token}" #=> String
    i.tags.each do |t| #=> Array
        puts "t.key = #{t.key}" #=> String
        puts "t.value = #{t.value}" #=> String        
    end
    i.security_groups.each do |g| #=> Array
        puts "g.group_name = #{g.group_name}"  #=> String
        puts "g.group_id = #{g.group_id}" #=> String
    end
    puts "i.source_dest_check = #{i.source_dest_check}" #=> true/false
    puts "i.hypervisor = #{i.hypervisor}" #=> String, one of "ovm", "xen"
    i.network_interfaces.each do |net| #=> Array
        puts "net.network_interface_id = #{net.network_interface_id}" #=> String
        puts "net.subnet_id = #{net.subnet_id}" #=> String
        puts "net.vpc_id = #{net.vpc_id}" #=> String
        puts "net.description = #{net.description}" #=> String
        puts "net.owner_id = #{net.owner_id}" #=> String
        puts "net.status = #{net.status}" #=> String, one of "available", "attaching", "in-use", "detaching"
        puts "net.mac_address = #{net.mac_address}" #=> String
        puts "net.private_ip_address = #{net.private_ip_address}" #=> String
        puts "net.private_dns_name = #{net.private_dns_name}" #=> String
        puts "net.source_dest_check = #{net.source_dest_check}" #=> true/false
        net.groups.each do |g| #=> Array
            puts "g.group_name = #{g.group_name}" #=> String
            puts "g.group_id = #{g.group_id}" #=> String
        end
        puts "net.attachment.attachment_id = #{net.attachment.attachment_id}" #=> String
        puts "net.attachment.device_index = #{net.attachment.device_index}" #=> Integer
        puts "net.attachment.status = #{net.attachment.status}" #=> String, one of "attaching", "attached", "detaching", "detached"
        puts "net.attachment.attach_time = #{net.attachment.attach_time}" #=> Time
        puts "net.attachment.delete_on_termination = #{net.attachment.delete_on_termination}" #=> true/false
        puts "net.association.public_ip = #{net.association.public_ip}" #=> String
        puts "net.association.public_dns_name =#{net.association.public_dns_name}" #=> String
        puts "net.association.ip_owner_id = #{net.association.ip_owner_id}" #=> String
        net.private_ip_addresses.each do |ip| #=> Array
            puts "ip.private_ip_address = #{ip.private_ip_address}" #=> String
            puts "ip.private_dns_name = #{ip.private_dns_name}" #=> String
            puts "ip.primary = #{ip.primary}" #=> true/false
            puts "ip.association.public_ip =#{ip.association.public_ip}" #=> String
            puts "ip.association.public_dns_name =#{ip.association.public_dns_name}" #=> String
            puts "ip.association.ip_owner_id =#{ip.association.ip_owner_id}" #=> String
        end
        net.ipv_6_addresses.each do |ipv6| #=> Array
            puts "ipv6.ipv_6_address = #{ipv6.ipv_6_address}" #=> String
        end
    end
    # puts "i.iam_instance_profile.arn = #{i.iam_instance_profile.arn}" #=> String
    # puts "i.iam_instance_profile.id = #{i.iam_instance_profile.id}" #=> String
    # puts "i.ebs_optimized = #{i.ebs_optimized}" #=> true/false
    # puts "i.sriov_net_support = #{i.sriov_net_support}" #=> String
    # puts "i.ena_support = #{i.ena_support}" #=> true/false
end
