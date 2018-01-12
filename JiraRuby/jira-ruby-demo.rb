require 'rubygems'
require 'jira-ruby'

options = {
  :username     => 'username',
  :password     => 'password',
  :site         => 'http://yourdomain.atlassian.net:443/',
  :context_path => '',
  :auth_type    => :basic
}

client = JIRA::Client.new(options)

# Show all projects
projects = client.Project.all

projects.each do |project|
  puts "Project -> key: #{project.key}, name: #{project.name}"
end

# Show all issues below project 'CREATIVE'
project = client.Project.find('CREATIVE')

project.issues.each do |issue|
  puts "#{issue.id} - #{issue.summary}"
end

