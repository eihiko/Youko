require 'watir-webdriver'
#require 'celerity'
require 'pry'
require 'cgi'
require 'logger'


class FacebookEngine
  include Selenium::WebDriver::Error
  include Watir::Exception
  #include Celerity::Exception

  def initialize
    @logger = Logger.new("facebookEngine.txt")
    @rescue_tries = 0
    #Watir::always_locate = true
    @b = Watir::Browser.new :chrome
    #@b = Celerity::Browser.new
    @b.goto "https://facebook.com"
    @b.text_field( id: "email").set "ooyooko@gmail.com"
    @b.text_field( id: "pass").set "Hackme00"
    @b.label(id: "loginbutton").button.click
    goto "https://facebook.com/messages"
  end

  def logger
    @logger
  end

  def friends
    @friends ||= scrape_friends
  end
  
  def indices
    @indices ||= scrape_indices
  end

  def scrape_friends
    goto "https://www.facebook.com/youko.ou.3/friends"
    friends = {}
    browser.element(data_pnref: "friends").when_present.lis.each do |li|
      friends[CGI.parse(URI.parse(li.a(data_hovercard: //).data_hovercard).query)["id"].first] = li.text.split("\n")[1];
    end  
    return friends
  end

  def scrape_indices
    indices = {} 
    friends.each do |id,name|
      indices[id] = current_index id
    end
    return indices
  end

  def update_index friend_id
    @indices[friend_id] = current_index friend_id
  end

  def current_index friend_id
    goto "https://www.facebook.com/messages/#{friend_id}"
    messages = browser.ul(id: "webMessengerRecentMessages")
    return [0,0] unless messages.present?
    #class is a keyword so I'm using the old shuttle notation to keep my syntax highlighting from breaking.
    return [messages.lis.last.id, messages.lis.last.divs(:class => "_3hi").count]
  end

  def send_messages friend_id, messages
    logger.info("Sending #{messages} to #{friend_id}")
    goto "https://www.facebook.com/messages/#{friend_id}"
    messages.each do |m|
      browser.textarea(:class => "uiTextareaNoResize").when_present.set m
      browser.input(id: "u_0_r").click
    end
    goto "https://www.facebook.com/messages/0"
  rescue UnknownObjectException
    if @rescue_tries < 5
      Logger.new("debug.txt").info("Catch UnknownObjectException")
      @rescue_tries += 1
      send_messages friend_id, messages
      @rescue_tries = 0
    else
      throw UnknownObjectException.new
    end
  end
      

  def messages
    goto "https://www.facebook.com/messages/0"
    friend_ids = []
    messages = {}
    browser.as(class: "_ky").each do |a|
      friend_ids << a.parent.parent.parent.id.split(":")[2]
    end
    friend_ids.each do |friend_id|
      messages[friend_id] = new_messages friend_id
    end
    return messages
  rescue UnknownObjectException 
    if @rescue_tries < 5
      Logger.new("debug.txt").info("Catch UnknownObjectException")
      @rescue_tries += 1
      ms = messages
      @rescue_tries = 0
      return ms
    else
      throw UnknownObjectException.new
    end
  rescue StaleElementReferenceError 
    if @rescue_tries < 5
      Logger.new("debug.txt").info("Catch StaleElementReferenceError")
      @rescue_tries += 1
      ms = messages
      @rescue_tries = 0
      return ms
    else
      throw StaleElementReferenceError.new
    end
  end

  def new_messages friend_id
    last_index = indices[friend_id]
    messages = messages_after_index friend_id, last_index
    indices[friend_id] = current_index friend_id
    return messages
  end
  
  def messages_after_index friend_id, index
    logger = Logger.new("benchmark.txt")
    logger.info("Entered messages_after_index()")
    logger.info("Redirecting to messages page")
    goto "https://www.facebook.com/messages/#{friend_id}"
    ms = []
    messages = browser.ul(id: "webMessengerRecentMessages")
    logger.info("Getting recent messages")
    lis = browser.ul(id: "webMessengerRecentMessages").when_present.lis.to_a
    logger.info("Counting messages...")
    c = lis.count
    logger.info("Message count: #{c}")
    loop do
      c -= 1
      break if c < 0
    logger.info("Getting  li")
      li = lis[c]
      logger.info("Getting hovercard")
      hovercard = li.element(data_hovercard: //)
      logger.info("Checking if Youko wrote this")
      begin
        next if "100009045663173" == CGI.parse(URI.parse(hovercard.data_hovercard).query)["id"].first
      rescue UnknownObjectException
        next
      end
      logger.info("Calculating li index")
      li_index = [li.id, li.divs(:class => "_3hi").count]

      if li_index[0] > index[0]
        logger.info("Adding all divs")
        li.divs(:class => "_3hi").each do |m|
          ms << m.text
        end
      elsif li_index[0] == index[0]
        logger.info("Adding some divs")
        li.divs(:class => "_3hi").to_a[index[1], li_index[1]].reverse.each do |m|
          ms << m.text
        end
      else
        logger.info("Found all unread messages")
        break
      end
    end
    return ms.reverse
  rescue UnknownObjectException
    if @rescue_tries < 5
      Logger.new("debug.txt").info("Catch UnknownObjectException")
      @rescue_tries += 1
      ms = messages_after_index friend_id, index
      @rescue_tries = 0
      return ms
    else
      throw UnknownObjectException.new
    end
  end
      

  def browser
    @b
  end

  def goto url
    unless base_url(url) == base_url(@b.url)
      begin
        @b.goto url
      rescue UnhandledAlertError
        @b.alert.ok
      end
    end
  end

  def refresh
    @b.refresh
  end

  def base_url url
    url.partition("?")[0].gsub("http://","").gsub("www.","")
  end

end



