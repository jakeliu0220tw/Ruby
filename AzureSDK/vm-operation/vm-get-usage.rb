require 'rest-client'
require 'json'

subscription_id = 'subscription_id'
tenant_id = 'tenant_id'
client_id = 'client_id'
client_secret = 'client_secret'
location = "southcentralus"

begin
    payload = { :grant_type => 'client_credentials', :client_id => client_id, :client_secret => client_secret, :resource => 'https://management.azure.com/' }
    response = RestClient.post("https://login.microsoftonline.com/#{tenant_id}/oauth2/token", payload)
    json_response = JSON.parse(response)
    token_type = json_response['token_type']
    access_token = json_response['access_token']
    
    #puts json_response
    puts "token_type = #{json_response["token_type"]}"
    puts "access_token = #{json_response["access_token"]}"
    
    url = "https://management.azure.com/subscriptions/#{subscription_id}/providers/Microsoft.Compute/locations/#{location}/usages?api-version=2017-12-01"

    headers = { :Authorization => "#{token_type} #{access_token}" }
    response = RestClient.get(url, headers)
    json_response = JSON.parse(response)
    
    puts "json_response = #{json_response}"
    usage_ary = json_response['value']
    usage_ary.each do |e|
        puts "#{e['name']['value']}, limit = #{e['limit']}, currentValue = #{e['currentValue']}"
    end
rescue Exception => ex
    puts " an error of type #{ex.class} happened, message is #{ex.message}"
end
