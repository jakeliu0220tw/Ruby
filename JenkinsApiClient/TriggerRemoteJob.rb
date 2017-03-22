require 'jenkins_api_client'

#@client = JenkinsApi::Client.new(:server_ip => 'localhost', :server_port => 8080, :username => 'admin', :password => 'M@cd0nald')
#@client = JenkinsApi::Client.new(:server_url => 'http://localhost:8080', :server_port => 8080, :username => 'admin', :password => 'M@cd0nald')

# The following call will return all jobs matching '^TryRun-helloworld^'
#jobs = @client.job.list("^TryRun-helloworld")
#puts jobs
#
#initial_jobs = @client.job.chain(jobs, 'success', ["all"])
#puts initial_jobs
#
#code = @client.job.build(initial_jobs[0])
#puts code

# The following code will list all jenkins job
#puts @client.job.list_all

#code = @client.job.build('TryRun-helloworld-windows-x86')
#puts code

#output = @client.job.get_console_output('TryRun-helloworld-windows-x86')
#puts output

#details = @client.job.list_details('TryRun-helloworld-windows-x86')
#puts details

#builds = @client.job.get_builds('TryRun-helloworld-windows-x86')
#puts builds

#build_status = @client.job.get_current_build_status('TryRun-helloworld-windows-x86')
#puts build_status

#test_results = @client.job.get_test_results('TryRun-helloworld-windows-x86', 0)
#puts test_results

#builds = @client.job.get_builds('TryRun-helloworld-windows-x86')
#puts builds

#params = {"node_list" => "FC-AA-14-A7-EC-29, FC-AA-14-A7-ED-04, FC-AA-14-A7-EC-82"}
#opts = {'build_start_timeout' => 30, 'poll_interval' => 5}
#build_num = @client.job.build('TryRun-test', params, opts)
#
#@client.logger.info "start building at #{Time.now}"
#build_status = 'running'
#while(build_status == 'running')
#  build_status = @client.job.get_current_build_status('TryRun-test')
#  @client.logger.info build_status
#  sleep 10 if build_status == 'running'
#end
#@client.logger.info "end building at #{Time.now}"
#
#fail "build fail -- TryRun-test" unless build_status == 'success'

# =====================================================================================================================================

@client = JenkinsApi::Client.new(:server_url => 'http://localhost:8080', :username => 'server.mgt', :password_base64 => 'changeme')

job_name = "Chef-job-start"
command_ary = ["playserver-stop", "playserver-deploy", "playserver-deploy-package", "playserver-start"]
address_list = "FC-AA-14-6C-A3-6D, FC-AA-14-A7-EC-82, FC-AA-14-A7-EC-29"

command_ary.each do |cmd|
  params = {"COMMAND" => cmd, "NODELIST" => address_list}
  opts = {'build_start_timeout' => 60, 'poll_interval' => 5}
  @client.logger.info "trigger jenkins job -- job_name=#{job_name}, command=#{cmd}"
      
  build_num = @client.job.build(job_name, params, opts)
  @client.logger.info "start jenkins job \"Chef-job-start\" at #{Time.now}"
  @client.logger.info "build_num = #{build_num}"
  
  build_status = 'running'
  while(build_status == 'running')
    build_status = @client.job.get_current_build_status(job_name)
    @client.logger.info build_status
    sleep 10 if build_status == 'running'
  end
  @client.logger.info "end jenkins job at #{Time.now}"
  @client.logger.info "build_status is #{build_status}"
  
  fail "build fail -- job_name=#{job_name}, command=#{cmd}" unless build_status == 'success'
end
