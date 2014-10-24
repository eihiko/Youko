require 'socket'
require 'thread'

class SocketAdaptor
  include Adaptor

  def initialize
    @server = TCPServer.new 13013
    @mutex = Mutex.new
    @corrs = []
    listener = Thread.new do
      loop do
        client = @server.accept
        @mutex.synchronize { @corrs << SocketCorr.new(client) }
      end
    end
  end

  def corrs
    @mutex.synchronize{ return @corrs }
  end

end

