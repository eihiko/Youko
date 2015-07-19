require 'watir-webdriver'
require 'pry'
require 'cgi'


class FacebookAdaptor

  def initialize
    @b = Watir::Browser.new :firefox
    @b.goto "https://facebook.com"
    @b.text_field( id: "email").set "ooyooko@gmail.com"
    @b.text_field( id: "pass").set "Hackme00"
    @b.label(id: "loginbutton").button.click
    goto "https://facebook.com/messages"
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
    browser.element(data_pnref: "friends").lis.each do |li|
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
    if messages.lis.count <= 0
      #When we go to the messages page for someone we've never messaged,
      #Facebook auto-generates a message draft. We must delete it so we can
      #Navigate away without causing a redirect confirmation alert.
      browser.a(class: "remove").click
      return [0,0]
    else
      #class is a keyword so I'm using the old shuttle notation to keep my syntax highlighting from breaking.
      return [messages.lis.last.id, messages.lis.last.divs(:class => "_3hi").count]
    end
  end


  def new_messages friend_id
    last_index = indices[friend_id]
    messages = messages_after_index friend_id, last_index
    indices[friend_id] = current_index friend_id
    return messages
  end
  
  def messages_after_index friend_id, index
    goto "https://www.facebook.com/messages/#{friend_id}"
    ms = []
    messages = browser.ul(id: "webMessengerRecentMessages")
    messages.lis.each do |li|
      li_index = [li.id, li.divs(:class => "_3hi").count]
      if li_index[0] > index[0]
        li.divs(:class => "_3hi").each do |m|
          ms << m.text
        end
      end
      if li_index[0] == index[0]
        li.divs(:class => "_3hi").to_a[index[1], li_index[1]].each do |m|
          ms << m.text
        end
      end
    end
    return ms
  end

  def browser
    @b
  end

  def goto url
    unless base_url(url) == base_url(@b.url)
      @b.goto url
    end
  end

  def refresh
    @b.refresh
  end

  def base_url url
    url.partition("?")[0].gsub("http://","").gsub("www.","")
  end

end

begin
  facebook = FacebookAdaptor.new
  binding.pry
rescue
  facebook.browser.close
ensure
  facebook.browser.close
end

