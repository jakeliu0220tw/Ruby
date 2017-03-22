require File.expand_path('../lib/websocket-eventmachine-server', __FILE__)
require 'json'
require "rubygems"
require "redis"
require "redis-objects"
require 'rbtrace'
require 'logger'
require './config/setting.rb'

class ChatRoomServer
  include Setting

  def initialize
    $logger = Logger.new("./log/ChatRoomServer.log", LOGGER_ROTATE_NUM, LOGGER_MAX_SIZE)
    $logger.level = eval(LOGGER_LEVEL)

    $chat_rooms = {} # (key, value) => (roomName, EM::Channel)
  end

  def run
    EM.epoll
    
    EM.run do
      $logger.info { "--- ChatRoomServer started with host = #{WEBSOCKET_HOST}, port = #{WEBSOCKET_PORT} ---" }
      WebSocket::EventMachine::Server.start(:host => WEBSOCKET_HOST, :port => WEBSOCKET_PORT) do |ws|
        # ws.onopen
        ws.onopen do |http_request|
          begin
            $logger.info { "WebSocket connection Open" }
            $logger.info { "http_request.headers = #{http_request.headers}" }
            $logger.info { "http_request.query = #{http_request.query}" }

            client_ip = remote_addr(ws)
            sec_websocket_key = http_request.headers["sec-websocket-key"]
            host_id = http_request.query.split("?")[1].split("&")[0].split("=")[0]
            host_id = 'default_host_id' if room_name.nil?
            user_id = http_request.query.split("?")[1].split("&")[1].split("=")[0]
            user_id = 'default_user_id' if user_id.nil?

            #TODO: avatar_url should be query by RESFUL API, passing user_id and get avatar_url
            avatar_url = "#{PORTAL_HOST}/images/thumb_default-avatar.png"

            channel = get_channel(room_name)
            client_id = channel.subscribe do |msg|
              # msg = { "nick_name" => 'Jake', "action" => 'chat', "data" => 'This is my message!' };
              parsed_data = JSON.parse(msg)
              nick_name = parsed_data["nick_name"] || 'guest'
              action = parsed_data["action"] || 'chat'
              data = parsed_data['data'] || ''
              json_data = { host_id: host_id, user_id: user_id, nick_name: nick_name, action: action, data: data, time: Time.now, avatar_url: avatar_url }.to_json
              ws.send json_data
            end
            $logger.info { "[#{room_name}##{client_id}] client_id = #{client_id}, client_ip = #{client_ip}, sec_websocket_key = #{sec_websocket_key}" }
            $logger.info { "[#{room_name}##{client_id}] room_name = #{room_name}, client_id = #{client_id}, join chatroom" }

            # ws.onmessage
            ws.onmessage do |msg, type|
              # msg = { "nick_name" => 'Jake', "action" => 'chat', "data" => 'This is my message!' };
              channel.push msg
              $logger.info { "[#{room_name}##{client_id}] receive msg, msg = #{msg}" }
            end

            # ws.onclose
            ws.onclose do |msg, type|
              channel.unsubscribe(client_id)
              $logger.info { "[#{room_name}##{client_id}] exit chatroom" }
            end
          rescue Exception => ex
            $logger.error { "An error of type #{ex.class} happened, message is #{ex.message}" }
            $logger.error { "#{ex.backtrace.join("\n")}" }
          end
        end # end of ws.onopen()
      end # end of WebSocket::EventMachine::Server.start()
    end # end of EM.run()
  end

  private

  def get_channel(room_name)
    return $chat_rooms.fetch(room_name) if $chat_rooms.key?(room_name)
    $chat_rooms.store(room_name, EM::Channel.new)
    $chat_rooms.fetch(room_name)
  end
  
  def remote_addr(ws)
    begin
      return ws.get_peername[2,6].unpack('nC4')[1..4].join('.')
    rescue Exception => ex
      $logger.error { "An error of type #{ex.class} happened, message is #{ex.message}" }
      $logger.error { "#{ex.backtrace.join("\n")}" }
    end
  end

end

############################################################################################

chat_room_server = ChatRoomServer.new
chat_room_server.run
