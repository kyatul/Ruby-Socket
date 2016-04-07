# Server side program for accepting a request
require 'socket'
require_relative 'server_logger'
require_relative 'constant_library'

class ServerRuby
  def initialize(host_name, port_name)
    @host = host_name.nil? ? 'localhost' : ARGV[0]
    @port = port_name.nil? ? 2000 : ARGV[1].to_i
    @logger = ServerLog.log(ConstantLibrary::LOG_PATH)

    launch_server
    run_server
  end

  def launch_server
    @server = TCPServer.open(@host, @port)
    @logger.info("Server setup made with host #{@host} and port #{@port}")
  end

  def run_server
    while true
         Thread.start(@server.accept) do |client|
           @logger.info('Incoming Connection Accepted')
           headers = ['http/1.1 200 ok',
                      "Content-Type: text/plain",
                      "Content-Language: en-US",
                      "Date: #{Time.now.ctime}",
                      'Connection: close',
                      'Server: Ruby'
                     ]
           client.puts(headers)
           client.close
           @logger.info('Connection Closed')
         end
        end
  end
end

ServerRuby.new(ARGV[0], ARGV[1])
