#!/usr/bin/env ruby

require 'azure_mgmt_resources'
require 'azure_mgmt_network'
require 'azure_mgmt_storage'
require 'azure_mgmt_compute'

NORTH_CENTRAL_US = 'northcentralus'
GROUP_NAME = 'gamehost-south'
VM_NAME = 'gamehost-south'

ENV['AZURE_SUBSCRIPTION_ID'] = 'AZURE_SUBSCRIPTION_ID'
ENV['AZURE_TENANT_ID'] = 'AZURE_TENANT_ID'
ENV['AZURE_CLIENT_ID'] = 'AZURE_CLIENT_ID'
ENV['AZURE_CLIENT_SECRET'] = 'AZURE_CLIENT_SECRET'

StorageModels = Azure::ARM::Storage::Models
NetworkModels = Azure::ARM::Network::Models
ComputeModels = Azure::ARM::Compute::Models
ResourceModels = Azure::ARM::Resources::Models

# This sample shows how to manage a Azure virtual machines using using the Azure Resource Manager APIs for Ruby.
#
# This script expects that the following environment vars are set:
#
# AZURE_TENANT_ID: with your Azure Active Directory tenant id or domain
# AZURE_CLIENT_ID: with your Azure Active Directory Application Client ID
# AZURE_CLIENT_SECRET: with your Azure Active Directory Application Secret
# AZURE_SUBSCRIPTION_ID: with your Azure Subscription Id
#
def run_example
  #
  # Create the Resource Manager Client with an Application (service principal) token provider
  #
  subscription_id = ENV['AZURE_SUBSCRIPTION_ID'] || '11111111-1111-1111-1111-111111111111' # your Azure Subscription Id
  provider = MsRestAzure::ApplicationTokenProvider.new(
      ENV['AZURE_TENANT_ID'],
      ENV['AZURE_CLIENT_ID'],
      ENV['AZURE_CLIENT_SECRET'])
  credentials = MsRest::TokenCredentials.new(provider)
  resource_client = Azure::ARM::Resources::ResourceManagementClient.new(credentials)
  resource_client.subscription_id = subscription_id
  network_client = Azure::ARM::Network::NetworkManagementClient.new(credentials)
  network_client.subscription_id = subscription_id
  storage_client = Azure::ARM::Storage::StorageManagementClient.new(credentials)
  storage_client.subscription_id = subscription_id
  compute_client = Azure::ARM::Compute::ComputeManagementClient.new(credentials)
  compute_client.subscription_id = subscription_id

  puts 'get a virtual machines ...'
  vm = compute_client.virtual_machines.get(GROUP_NAME, VM_NAME)
  puts "vm = #{vm}"
  puts "vm.availability_set = #{vm.availability_set}"
  puts "vm.diagnostics_profile = #{vm.diagnostics_profile}"
  puts "vm.hardware_profile = #{vm.hardware_profile}"
  puts "vm.instance_view = #{vm.instance_view}"
  puts "vm.license_type = #{vm.license_type}"
  puts "vm.network_profile = #{vm.network_profile}"
  puts "vm.os_profile = #{vm.os_profile}"
  puts "vm.plan = #{vm.plan}"
  puts "vm.provisioning_state = #{vm.provisioning_state}"
  puts "vm.resources = #{vm.resources}"
  puts "vm.storage_profile = #{vm.storage_profile}"
  puts "vm.vm_id = #{vm.vm_id}"

  puts 'print_item vm ...'
  print_item vm
  puts 'print_item vm.hardware_profile ...'
  print_item vm.hardware_profile
  puts 'print_item vm.network_profile ...'
  print_item vm.network_profile
  puts 'print_item vm.network_profile.network_interfaces.first ...'
  print_item vm.network_profile.network_interfaces.first
  puts 'print_item vm.storage_profile ...'
  print_item vm.storage_profile
  puts 'print_item vm.storage_profile.os_disk ...'
  print_item vm.storage_profile.os_disk
  puts 'print_item vm.storage_profile.data_disks ...'
  vm.storage_profile.data_disks.each { |e| print_item e }  

  puts 'print_item vm.instance_view ...'
  print_item vm.instance_view
  # puts 'print_item vm.getInstanceView ...'
  # print_item vm.getInstanceView
  # puts 'print_item vm.getWithInstanceView ...'
  # print_item vm.getWithInstanceView

  # puts 'print_item compute_client ...'
  # print_item compute_client

  # puts 'print_item promise ...'
  # #promise = compute_client.virtual_machines.start_async(GROUP_NAME, VM_NAME)
  # promise = compute_client.virtual_machines.deallocate_async(GROUP_NAME, VM_NAME)
  # print_item promise

  # puts 'print_item promise.value ...'
  # print_item promise.value

  # puts 'print_item promise.value.request ...'
  # print_item promise.value.request

  # puts 'print_item promise.value.response ...'
  # print_item promise.value.response

  # puts 'print_item promise.value.response.env ...'
  # print_item promise.value.response.env
  # puts promise.value.response.env

  # puts "print_item promise.value.response.env[:status] ..."
  # puts promise.value.response.env[:status]

  # puts "print_item promise.value.response.env[:reason_phrase] ..."
  # puts promise.value.response.env[:reason_phrase]
end

def print_group(resource)
  puts "\tname: #{resource.name}"
  puts "\tid: #{resource.id}"
  puts "\tlocation: #{resource.location}"
  puts "\ttags: #{resource.tags}"
  puts "\tproperties:"
  print_item(resource.properties)
end

def print_item(resource)
  resource.instance_variables.sort.each do |ivar|
    str = ivar.to_s.gsub /^@/, ''
    if resource.respond_to? str.to_sym
      puts "\t\t#{str}: #{resource.send(str.to_sym)}"
    end
  end
  puts "\n\n"
end

if $0 == __FILE__
  run_example
end
