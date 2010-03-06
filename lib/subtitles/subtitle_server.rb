require 'xmlrpc/client'
require 'set'
require 'base64'
require 'stringio'
require 'zlib'

require 'common'

$debug = true

class String
  # transform underscore to camel case
  def to_camel
    clone.split('_').each{|w| w.capitalize!}.join
  end
end

class SubtitleServerWrongStatus < RuntimeError
  def initialize(string=nil)
    super string
  end
end

class SubtitleServer
  def initialize
    init
    begin
      yield self
    ensure
      finalize
    end
  end

  def search(query)
    search_subtitles([query])
  end

  def sub_text(id)
    res = download_subtitles([id])
    base64 = res['data'][0]['data']
    res = ""
    StringIO.open(Base64::decode64(base64)) do |input|
      gz = Zlib::GzipReader.new(input)
      text =  gz.read.split(/\n\s*\n+/) # split
      # remove first two lines (id and time)
      text.map!{|t| t.split("\n")[2..-1].join("\n")}
      res = text[10..-5].join("\n\n")
      gz.close
    end
    res
  end

private
  # sets or resets the server
  def reset_server
    @server = XMLRPC::Client.new2(URL)
  end

  def init
    reset_server
    puts "logging in..." if $debug
    result = log_in(USERNAME, PASSWORD, LANGUAGE, USERAGENT)
    puts "successfully logged in" if $debug
    @token = result["token"]
  end

  # TODO: are those methods public or private now?
  def method_missing(method, *args)
    call(method, *args)
  end

  def call(method, *args)
    reset_server # seems necessary, to avoid weird errors =)
    args = [@token] + args unless NO_TOKEN[method]
    result = @server.call(method.to_s.to_camel, *args)
    unless NO_STATUS[method]
      if result["status"] !~ /^200/
        warn result["status"] + ">: " + method.to_s + ' ' + args.join(' ')
        raise SubtitleServerWrongStatus
      end
    end
    result
  end

  def finalize
    puts "logging out..." if $debug
    log_out
    puts "successfully logged out" if $debug
  end

  URL = "http://api.opensubtitles.org/xml-rpc"
  USERNAME = ""
  PASSWORD = ""
  LANGUAGE = "en"
  USERAGENT = "langid"

  # rcp methods that don't need a token
  NO_TOKEN = {
    :info => true,
    :log_in => true,
  }

  # rpc methods without a status response
  NO_STATUS = {
    :info => true,
    :search_subtitles => true
  }
end
