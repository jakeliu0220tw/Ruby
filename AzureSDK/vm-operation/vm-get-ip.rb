require 'rest-client'

subscription_id = 'subscription_id'
tenant_id = 'tenant_id'
client_id = 'client_id'
client_secret = 'client_secret'
resource_group = 'azure_qa_1'
vm_name = resource_group
public_ip_address_name = resource_group

begin
    payload = { :grant_type => 'client_credentials', :client_id => client_id, :client_secret => client_secret, :resource => 'https://management.azure.com/' }
    response = RestClient.post("https://login.microsoftonline.com/#{tenant_id}/oauth2/token", payload)
    json_response = JSON.parse(response)
    token_type = json_response['token_type']
    access_token = json_response['access_token']
    
    #puts json_response
    puts "token_type = #{json_response["token_type"]}"
    puts "access_token = #{json_response["access_token"]}"
    
    url = "https://management.azure.com/subscriptions/#{subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/publicIPAddresses/#{public_ip_address_name}?api-version=2016-09-01"
    
    headers = { :Authorization => "#{token_type} #{access_token}" }
    response = RestClient.get(url, headers)
    json_response = JSON.parse(response)
    
    puts "json_response = #{json_response}"
    puts "ipAddress = #{json_response["properties"]["ipAddress"]}"
    puts "ipAddress = nil" if json_response["properties"]["ipAddress"].nil?
rescue Exception => ex
    puts " an error of type #{ex.class} happened, message is #{ex.message}"
end
