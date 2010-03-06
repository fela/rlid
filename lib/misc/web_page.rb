class NetworkError < StandardError
end

class WebPage
  attr_reader :url

  def initialize(url)
    @url = url
  end

  # not really random, finds the most central link
  def random_link
    dump = `lynx -dump #{@url}`

    # the second part contains the visible links
    links = get_links_from_lynx_output(dump).split("\n")

    # take the most central link
    link = links[links.size/2]

    # get only the actual url
    data = link.match(LYNX_LINK_TO_URL)
    if data == nil
      raise NetworkError, "'#{link}' is not a link"
    end

    url = data[1] # fist match
    WebPage.new(url)
  end

  def text
    `w3m -dump '#{@url}'`
  end

  def longest_paragraph
    paragraphs = text.split(/\n\s*\n/)
    paragraphs.each do |par|
      par.gsub!(/^\s+/, '')
      par.gsub!(/\s+$/, '')
    end
    #paragraphs.delete_if {|p| p.size < 100 || not_useful(p) }
    paragraphs.sort! {|a, b| a.size <=> b.size}
    paragraphs.last
  end

private
  LYNX_DIV1 = "References\n\n   Visible links\n" # separation with hidden links
  LYNX_DIV2 = "References\n\n"                   # division without hidden links
  LYNX_DIV_HIDDEN = "\n\n   Hidden links:\n"
  LYNX_LINK_TO_URL = /\s+\d+\. ?(http:\/\/.+)/



  # sorry for the unintentional pun :)
  def get_links_from_lynx_output(lynx_output)
    # suppose there are hidden links
    site_parts = lynx_output.split(LYNX_DIV1)

    if site_parts.size == 1
      # there wheren't hidden links
      site_parts = lynx_output.split(LYNX_DIV2)

      # make sure the split was successful
      if site_parts.size != 2
        raise NetworkError, "no links found or invalid lynx output"
      end
    else
      # there where hidden links remove them
      site_parts[1, 1] = site_parts[1].split(LYNX_DIV_HIDDEN)

      # make sure the split was successful
      if site_parts.size != 3
        raise NetworkError, "no links found or invalid lynx output"
      end
    end

    return site_parts[1]
  end

  def not_useful(p)
    # substitute unuseful text with ~
    changed = p.gsub('  ', '~~')
    changed.gsub!(/\D\D\D\D/, '~~~~')

    p = changed
    p.size < changed.count('~') * 50
    false
  end
end # class
