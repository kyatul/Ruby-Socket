# Server side program for accepting a request
require 'socket'
require 'uri'
require_relative 'server_logger'
require_relative 'routes'

class ServerRuby
  CONTENT_TYPE_DICTIONARY = {
                          'html' => 'text/html',
                          'txt' => 'text/plain',
                          'png' => 'image/png',
                          'jpg' => 'image/jpeg'
                          }
  DEFAULT_CONTENT_TYPE = 'application/octet-stream'
  LOG_PATH = './log/server_log.log'
  WEB_PATH = './public'
  LAUNCH_FILE = 'index.html'

  def initialize(host_name, port_name)
    @host = host_name.nil? ? 'localhost' : ARGV[0]
    @port = port_name.nil? ? 2000 : ARGV[1].to_i
    @logger = ServerLog.log(LOG_PATH)

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
           request = client.gets
           method, path = extract_path(request)
           puts "method #{method} path #{path}"

           if File.exist?(path) && !File.directory?(path)
             @logger.info('Returing requested successfully')
             response, status = Routes.response(method, path)
             puts "1"
             headers = ["HTTP/1.1 #{status}",
                        "Content-Type: #{content_type(path)}",
                        "Content-Language: en-US",
                        "Content-Length: #{response.size}",
                        "Date: #{Time.now.ctime}",
                        'Connection: close',
                        'Server: Ruby'
                       ]
              puts "2"
             client.puts(headers)
             client.puts("\r\n")
             client.puts(response)
           else
            @logger.info('File Not Found')
            response = 'File Not Found'
            headers = ["HTTP/1.1 404 Not Found",
                      "Content-Type: text/plain",
                      "Content-Language: en-US",
                      "Content-Length: #{response.size}",
                      "Date: #{Time.now.ctime}",
                      'Connection: close',
                      'Server: Ruby'
                     ]
             client.puts(headers)
             client.puts("\r\n")
             client.puts(response)
           end
           client.close
           @logger.info('Connection Closed')
         end
      end
  end

  def content_type(path)
    extension = File.extname(path).split('.').last
    CONTENT_TYPE_DICTIONARY.fetch(extension, DEFAULT_CONTENT_TYPE)
  end

  def extract_path(request)
    request = request.split(' ')
    request_uri = request[1]
    path = URI.unescape(URI(request_uri).path)
    path = LAUNCH_FILE if path.eql?('/')
    return request[0], File.join(WEB_PATH, path)
  end
end

ServerRuby.new(ARGV[0], ARGV[1])
