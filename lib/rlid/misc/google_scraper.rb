require 'rubygems'
require 'scrubyt'

require 'rlid/web_page'

class GoogleScraper
  # @language is a language code
  # @start is the first result index
  # @query the query we are searching for
  attr_accessor :language, :start, :query

  #constructor
  def initialize
    @language = :en
    @start = 0
    @query = nil
  end

  def search(number_of_entries)
    if @query == nil
      raise "no query has been set"
    end

    res = []
    if number_of_entries < 1
      raise ArgumentError
    end

    pages = number_of_entries/ENTRIES_PER_PAGE
    pages.times do
      new_results = scrape
      if new_results.size != ENTRIES_PER_PAGE
        raise NetworkError
      end
      res += new_results
      @start += ENTRIES_PER_PAGE
      # antidetection pause
      sleep 1
    end
    res += scrape[0, number_of_entries % ENTRIES_PER_PAGE]

    @start -= ENTRIES_PER_PAGE * pages

    res.map {|url| WebPage.new(url)}
  end


private
  ENTRIES_PER_PAGE = 10

  def create_google_url
    "http://www.google.com/search?lr=lang_#{@language}&q=#{@query}&start=#{@start}"
  end

  # returns an array of the urls
  def scrape
    google_url = create_google_url
    google_data = Scrubyt::Extractor.define do
      fetch google_url

      link_title "//a[@class='l']", :write_text => true do
        link_url
      end
    end
    google_data.to_hash.map {|r| r[:link_url]}
  end
end
