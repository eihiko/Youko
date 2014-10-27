require 'socket'
require './youko.rb'
require './Corr/Socket/socket_corr.rb'

class Client

  def initialize
    @server = TCPServer.new 13014
    puts "Waiting for display..."
    @display = SocketCorr.new(@server.accept)
    puts "Display found!"

    puts "Finding Youko..."
    @youko = SocketCorr.new(TCPSocket.new 'localhost', 13013)
    puts "Youko found!"

    Thread.new do
      while @youko.active?
        messages = @youko.listen
        display "Youko", *messages
      end
    end

    while @youko.active?
      print "~> "
      message = gets.chomp
      @youko.tell message
      display "Me", message
    end
  end

  def display speaker, *messages
    messages.each { |message| @display.tell "#{speaker}: #{message}" }
  end

end

Client.new
