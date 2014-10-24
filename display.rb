require 'socket'
require './youko.rb'
require './Corr/Socket/socket_corr.rb'

class Display

  def initialize
    puts "Finding Client..."
    @client = SocketCorr.new(TCPSocket.new 'localhost', 13014)
    puts "Client found!\n\n"
    while @client.active?
      @client.listen.each { |message| puts message }
    end
    puts "Client lost. Quitting!"
  end

end

Display.new
