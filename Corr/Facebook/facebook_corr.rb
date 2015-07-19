class SocketCorr
  include Corr
  require "securerandom"

  attr_accessor :id

  def initialize client
    @client = client
    @buffer = ""
    @active = true
    self.id = SecureRandom.uuid()
  end

  def listen
    data = @client.recv_nonblock(512)
    @active = false if data == ""
    @buffer << data
    messages = @buffer.split("[~!~]", -1)
    @buffer = messages.pop || ""
    return messages
  rescue IO::WaitReadable => e
    return []
  end
  
  def tell *messages
    messages.each { |message| @client.sendmsg "#{message}[~!~]" }
  end
  
  def active?
    @active
  end

end
