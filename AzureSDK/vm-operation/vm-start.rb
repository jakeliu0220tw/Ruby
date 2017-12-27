#!/usr/bin/env ruby

require 'azure_mgmt_resources'
require 'azure_mgmt_network'
require 'azure_mgmt_storage'
require 'azure_mgmt_compute'

GROUP_NAME = 'southeastasia-2'
VM_NAME = 'southeastasia-2'

StorageModels = Azure::ARM::Storage::Models
NetworkModels = Azure::ARM::Network::Models
ComputeModels = Azure::ARM::Compute::Models
ResourceModels = Azure::ARM::Resources::Models

ENV['AZURE_SUBSCRIPTION_ID'] = 'AZURE_SUBSCRIPTION_ID'
ENV['AZURE_TENANT_ID'] = 'AZURE_TENANT_ID'
ENV['AZURE_CLIENT_ID'] = 'AZURE_CLIENT_ID'
ENV['AZURE_CLIENT_SECRET'] = 'AZURE_CLIENT_SECRET'

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

  puts 'Starting the virtual machine...'
  compute_client.virtual_machines.start(GROUP_NAME, VM_NAME)

  # puts 'Your virtual machine has started. Lets restarting the virtual machine.'
  # puts 'Press any key to continue'
  # gets
  # puts 'Re-Starting the virtual machine...'
  # compute_client.virtual_machines.restart(GROUP_NAME, VM_NAME)
  # puts 'Your virtual machine is now on.'
  # gets
end

if $0 == __FILE__
  run_example
end
