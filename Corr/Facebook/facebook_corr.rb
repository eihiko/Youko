class FacebookCorr
  include Corr
  require "securerandom"
  require "logger"

  attr_accessor :id

  def initialize friend_id, name
    @friend_id = friend_id
    @name = name
    @active = true
    @inbox = []
    @outbox = []
    self.id = SecureRandom.uuid()
  end

  def fill_inbox messages
    @inbox.concat messages
  end

  def fill_outbox messages
    @outbox.concat messages
  end

  def empty_inbox
    messages = @inbox
    @inbox = []
    return messages
  end

  def empty_outbox
    messages = @outbox
    @outbox = []
    return messages
  end

  def listen
    return empty_inbox
  end
  
  def tell *messages
    fill_outbox messages
  end
  
  def active?
    @active
  end

end
