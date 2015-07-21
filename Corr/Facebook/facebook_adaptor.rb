require "thread"
require "logger"
require_relative "facebook_engine"
class FacebookAdaptor
  include Adaptor

  def initialize
    @facebook = FacebookEngine.new
    @mutex = Mutex.new
    @corrs = {}
    facebook.friends.each do |friend_id, name|
      @corrs[friend_id] = FacebookCorr.new(friend_id, name)
    end
    facebook.indices
    Thread.abort_on_exception = true
    @listener = Thread.new do
      loop do
        messages = facebook.messages
        messages.each do |friend_id, ms|
          @mutex.synchronize { @corrs[friend_id].fill_inbox(ms) }
        end
        @corrs.each do |friend_id, corr|
          messages = corr.empty_outbox
          facebook.send_messages friend_id, messages unless messages.empty?
        end
      end
    end
  end

  def facebook
    @facebook
  end

  def corrs
    @mutex.synchronize{ return @corrs.values }
  end

  def status
    @listener.status
  end

end

