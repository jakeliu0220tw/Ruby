require 'rest-client'

subscription_id = 'subscription_id'
tenant_id = 'tenant_id'
client_id = 'client_id'
client_secret = 'client_secret'
resource_group = 'southeastasia-3'
vm_name = resource_group

payload = { :grant_type => 'client_credentials', :client_id => client_id, :client_secret => client_secret, :resource => 'https://management.azure.com/' }
response = RestClient.post("https://login.microsoftonline.com/#{tenant_id}/oauth2/token", payload)
json_response = JSON.parse(response)
token_type = json_response['token_type']
access_token = json_response['access_token']

#puts json_response
puts "token_type = #{json_response["token_type"]}"
puts "access_token = #{json_response["access_token"]}"

url = "https://management.azure.com/subscriptions/#{subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Compute/virtualMachines/#{vm_name}/InstanceView?api-version=2016-04-30-preview"
headers = { :Authorization => "#{token_type} #{access_token}" }
response = RestClient.get(url, headers)
json_response = JSON.parse(response)
puts json_response
puts json_response['statuses']

power_state = 'unknown'
json_response['statuses'].each do |s|
    power_state = s['code'].split('/').last if s['code'].include? 'PowerState'
end
puts "power_state = #{power_state}"
