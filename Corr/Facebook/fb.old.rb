require 'watir-webdriver'
require 'pry'


class FacebookAdaptor

  def initialize
    @b = Watir::Browser.new :chrome
    @b.goto "https://facebook.com"
    @b.text_field( id: "email").set "ooyooko@gmail.com"
    @b.text_field( id: "pass").set "Hackme00"
    @b.label(id: "loginbutton").button.click
    goto "https://facebook.com/messages"
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

  def friendnav
    @b.ul(id: "wmMasterViewThreadlist")
  end

  def friend_messages id
    goto "https://facebook.com/messages/#{id}"
    @b.ul(id: "webMessengerRecentMessages")
  end

  def friend_messages_after datetime, size, id
    msg = []
    friend_messages(id).lis.each do |li|
      if (li.class_name.split.include?("webMessengerMessageGroup"))
        if(li.text.lines[1].chomp == friend_name(id))
          li.divs(class: "_3hi").each do |d|
            msg << [DateTime.parse(li.text.lines[0]),li.text.lines[1].chomp,d.text]
          end
        end
      end
    end
    return msg.find_all {|m| m[0] >= datetime}.tap { |m| m[size, m.length] }
  end

  def friend_messages_n n, id
    msg = []
    friend_messages(id).lis.each do |li|
      if (li.class_name.split.include?("webMessengerMessageGroup"))
        if(li.text.lines[1].chomp == friend_name(id))
          li.divs(class: "_3hi").each do |d|
            msg << [DateTime.parse(li.text.lines[0]),li.text.lines[1].chomp,d.text]
          end
        end
      end
    end
    return msg[msg.length-n,msg.length]
  end


  def corrs
    friendnav.lis.map do |li|
      FacebookCorr.new(self, li.id.split(":")[2])
    end
  end

  def friend_name id
    friendnav.lis.each do |li|
      if id == li.id.split(":")[2]
        return li.text.lines[0].chomp
      end
    end
    return nil
  end

  def friend_new_message_count id
    friendnav.lis.map do |li|
      if id == li.id.split(":")[2]
        return li.text.lines[3].split[0].to_i
      end
    end
    return nil
  end

end

class FacebookCorr

  def initialize facebook, id
    @facebook = facebook
    @id = id
    @last_time = DateTime.now
  end

  def fetch_messages
    puts "finding unseen messages..."
    msg = @facebook.friend_messages_n(@facebook.friend_new_message_count(@id), @id)
    @facebook.refresh
    @last_time = DateTime.now
    return msg.map { |m| m[2] }
  end


  def id
    @id
  end

  def name
    @facebook.friend_name(@id)
  end

  def new_message_count
    @facebook.friend_new_message_count(@id)
  end

  def listen
  end

  def tell
  end

end

class MessageGroup

  def initialize facebook
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

