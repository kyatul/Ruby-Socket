require 'logger'

class ServerLog
  def self.log(destination)
    if @logger.nil?
      @logger = Logger.new(destination)
      @logger.level = Logger::DEBUG
      @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
    end
    @logger
  end
end
