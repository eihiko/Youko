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

  def scrape_friends
    goto "https://www.facebook.com/youko.ou.3/friends"
    friends = {}
    browser.element(data_pnref: "friends").lis.each do |li|
      friends[CGI.parse(URI.parse(li.a(data_hovercard: //).data_hovercard).query)["id"]] = li.text.split("\n")[1];
    end  
    return friends
  end

  def friends
    @friends ||= scrape_friends
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
#
#module Watir
#  class ElementLocator    
#    alias :old_normalize_selector :normalize_selector
#
#    def normalize_selector(how, what)
#      case how
#      when :data_pnref
#        [how, what]
#      else
#        old_normalize_selector(how, what)
#      end
#    end
#  end
#end

begin
  facebook = FacebookAdaptor.new
  binding.pry
rescue
  facebook.browser.close
ensure
  facebook.browser.close
end

