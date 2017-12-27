#!/usr/bin/env ruby

require 'azure_mgmt_resources'
require 'azure_mgmt_network'
require 'azure_mgmt_storage'
require 'azure_mgmt_compute'

SOURTH_CENTRAL_US = 'southcentralus'
GROUP_NAME = 'azureuser001'

class Deployer

  # Initialize the deployer class with subscription, resource group and resource group location. The class will raise an
  # ArgumentError if there are empty values for Tenant Id, Client Id or Client Secret environment variables.
  #
  # @param [String] subscription_id the subscription to deploy the template
  # @param [String] resource_group the resource group to create or update and then deploy the template
  # @param [String] resource_group_location the location of the resource group
  def initialize(subscription_id, resource_group, resource_group_location)
    raise ArgumentError.new("Missing template file 'template.json' in current directory.") unless File.exist?('template.json')
    raise ArgumentError.new("Missing parameters file 'parameters.json' in current directory.") unless File.exist?('parameters.json')
    @resource_group = resource_group
    @subscription_id = subscription_id
	@resource_group_location = resource_group_location
    provider = MsRestAzure::ApplicationTokenProvider.new(
        ENV['AZURE_TENANT_ID'],
        ENV['AZURE_CLIENT_ID'],
        ENV['AZURE_CLIENT_SECRET'])
    credentials = MsRest::TokenCredentials.new(provider)
    @client = Azure::ARM::Resources::ResourceManagementClient.new(credentials)
    @client.subscription_id = @subscription_id
  end

  # Deploy the template to a resource group
  def deploy
    # ensure the resource group is created
    params = Azure::ARM::Resources::Models::ResourceGroup.new.tap do |rg|
      rg.location = @resource_group_location
    end
    @client.resource_groups.create_or_update(@resource_group, params)

    # build the deployment from a json file template from parameters
    template = File.read(File.expand_path(File.join(__dir__, 'template.json')))
    deployment = Azure::ARM::Resources::Models::Deployment.new
    deployment.properties = Azure::ARM::Resources::Models::DeploymentProperties.new
    deployment.properties.template = JSON.parse(template)
    deployment.properties.mode = Azure::ARM::Resources::Models::DeploymentMode::Incremental

    # build the deployment template parameters from Hash to {key: {value: value}} format
    deploy_params = File.read(File.expand_path(File.join(__dir__, 'parameters.json')))
    
    param_json = JSON.parse(deploy_params)
    param_json["parameters"]["location"]["value"] = "#{@resource_group_location}"
    param_json["parameters"]["resourceGroup"]["value"] = "#{@resource_group}"
    param_json["parameters"]["virtualMachineName"]["value"] = "#{@resource_group}-vm"
    param_json["parameters"]["virtualNetworkName"]["value"] = "#{@resource_group}-vnet"
    param_json["parameters"]["networkInterfaceName"]["value"] = "#{@resource_group}-nic"
    param_json["parameters"]["networkSecurityGroupName"]["value"] = "#{@resource_group}-nsg"
    param_json["parameters"]["publicIpAddressName"]["value"] = "#{@resource_group}-ip"
    #TODO: get imageId from DB, by location & image created date
    param_json["parameters"]["imageId"]["value"] = "/subscriptions/802136ca-e0a8-447c-b138-fa22e3db978f/resourceGroups/south_central/providers/Microsoft.Compute/images/GameHost-image-20170814174158"
    puts param_json["parameters"]

    # deployment.properties.parameters = JSON.parse(deploy_params)["parameters"]
    deployment.properties.parameters = param_json["parameters"]

    # put the deployment to the resource group
    @client.deployments.create_or_update(@resource_group, "#{@resource_group}-deploy", deployment)
  end
end

def run_example
  # create resource group & vm, default state of vm is 'running'
  vm_create(GROUP_NAME, SOURTH_CENTRAL_US)

  # stop vm
  vm_stop(GROUP_NAME)

  # start vm
  vm_start(GROUP_NAME)

  # delete resource group & vm
  vm_delete(GROUP_NAME)
end

def vm_create(resource_group, resource_group_location)
  subscription_id = 'subscription_id'

  # Initialize the deployer class
  deployer = Deployer.new(subscription_id, resource_group, resource_group_location)

  # Deploy the template
  puts "Beginning the deployment... \n\n"
  deployment = deployer.deploy
  puts "Done deploying!!"
end

def vm_start(resource_group)
  subscription_id = 'subscription_id'
  tenant_id = 'tenant_id'
  client_id = 'client_id'
  client_secret = 'client_secret'

  provider = MsRestAzure::ApplicationTokenProvider.new(tenant_id, client_id, client_secret)
  credentials = MsRest::TokenCredentials.new(provider)
  compute_client = Azure::ARM::Compute::ComputeManagementClient.new(credentials)
  compute_client.subscription_id = subscription_id

  puts 'Starting the virtual machine...'
  vm_name = "#{resource_group}-vm"
  compute_client.virtual_machines.start(resource_group, vm_name)
end

def vm_stop(resource_group)
  subscription_id = 'subscription_id'
  tenant_id = 'tenant_id'
  client_id = 'client_id'
  client_secret = 'client_secret'

  provider = MsRestAzure::ApplicationTokenProvider.new(tenant_id, client_id, client_secret)
  credentials = MsRest::TokenCredentials.new(provider)
  compute_client = Azure::ARM::Compute::ComputeManagementClient.new(credentials)
  compute_client.subscription_id = subscription_id

  puts 'Turning off the virtual machine...'
  vm_name = "#{resource_group}-vm"
  compute_client.virtual_machines.deallocate(resource_group, vm_name)
end

def vm_delete(resource_group)
  subscription_id = 'subscription_id'
  tenant_id = 'tenant_id'
  client_id = 'client_id'
  client_secret = 'client_secret'

  provider = MsRestAzure::ApplicationTokenProvider.new(tenant_id, client_id, client_secret)
  credentials = MsRest::TokenCredentials.new(provider)
  resource_client = Azure::ARM::Resources::ResourceManagementClient.new(credentials)
  resource_client.subscription_id = subscription_id

  puts 'Delete Resource Group & virtual machine...'
  resource_client.resource_groups.delete(resource_group)
  puts "\nDeleted: #{resource_group}"  
end

if $0 == __FILE__
  run_example
end
