require 'aws-sdk'
require 'parse-cron'
require 'logger'

class Operator
  
  def initialize(region)
    @client = Aws::EC2::Client.new(
        access_key_id: 'ACCESS_KEY_ID',
        secret_access_key: 'SECRET_ACCESS_KEY',
        region: region
    )
    @ec2 = Aws::EC2::Resource.new(client: @client)
    @stop_list = []
    @start_list = []
    @logger = Logger.new("#{File.dirname(__FILE__)}/#{region}.log", 5, 5120000)
    @logger.level = Logger::DEBUG
  end
  
  def auto_stop_start    
    @ec2.instances.each do |ins|
      begin
        # check AutoStop tag
        if ins.state.name == 'running' || ins.state.name == 'pending'
          ins.tags.each do |t|        
            if t.key == 'AutoStop'
              cron_parser = CronParser.new(t.value)
              most_recent_time = cron_parser.last(Time.now)
              current_time = Time.now
              diff = (current_time - most_recent_time).to_i.abs
              # add into stop_list if most_recent_time and current_time within 6 hours
              @stop_list << ins if current_time >= most_recent_time && diff < (6*60*60)
            end
          end
        end        
        # check AutoStart tag
        if ins.state.name == 'stopped'
          ins.tags.each do |t|
            if t.key == 'AutoStart'
              cron_parser = CronParser.new(t.value)        
              most_recent_time = cron_parser.last(Time.now)
              current_time = Time.now
              diff = (current_time - most_recent_time).to_i.abs
              # add into start_list if most_recent_time and current_time within 6 hours
              @start_list << ins if current_time >= most_recent_time && diff < (6*60*60)
            end
          end
        end
      rescue Exception => ex
        @logger.error { "error happen in parsing ec2 instance => #{ins.id}" }
      end
    end
    
    # execute auto stop action
    @stop_list.each do |ins|
      @logger.info { 'stop instance ...' }
      @logger.info { "ID: #{ins.id}, State: #{ins.state.name}" }
      stop_instance(ins)
      @logger.info { 'done' }
    end
    
    # execute auto start action
    @start_list.each do |ins|
      @logger.info { 'start instance ...' }
      @logger.info { "ID: #{ins.id}, State: #{ins.state.name}" }      
      start_instance(ins)
      @logger.info { 'done' }
    end    
  end  
  
  private
  
  def stop_instance(ins)
    if ins.exists?
      case ins.state.name
      when 'shutting-down'
        @logger.warn {"#{ins.id} is shutting-down, you cannot stop it"}
      when 'terminated'
        @logger.warn {"#{ins.id} is terminated, you cannot stop it"}
      when 'stopping'
        @logger.warn {"#{ins.id} is stopping, it will be stopped in a bit"}
      when 'stopped'
        @logger.warn {"#{ins.id} is already stopped"}
      else
        # in pending or running state
        ins.stop
      end
    end
  end
  
  def start_instance(ins)
    if ins.exists?
      case ins.state.name
      when 'pending'
        @logger.warn {"#{ins.id} is pending, so it will be running in a bit"}
      when 'running' 
        @logger.warn {"#{ins.id} is already started"}
      when 'shutting-down'
        @logger.warn {"#{ins.id} is shutting-down, you cannot start it"}
      when 'terminated' 
        @logger.warn {"#{ins.id} is terminated, so you cannot start it"}
      when 'stopping' 
        @logger.warn {"#{ins.id} is stopping, so you cannot start it"}
      else
        # in stopped state
        ins.start
      end
    end
  end
end

operator = Operator.new('us-east-1')
operator.auto_stop_start

operator = Operator.new('us-west-2')
operator.auto_stop_start

operator = Operator.new('eu-west-1')
operator.auto_stop_start

