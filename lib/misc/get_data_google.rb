# To change this template, choose Tools | Templates
# and open the template in the editor.

require "google_scraper"
require "languages"

gs = GoogleScraper.new
gs.language = :it
gs.start = 50
gs.query = "di"

#url = gs.search(1).first


DATA_DIRECTORY = '~/.langid'

language = :it
dir = DATA_DIRECTORY + '/' + language.to_s
FileUtils.makedirs(dir)
Dir.chdir(dir) do
  pages = gs.search(12)
  File.open("raw_text", "w") do |f|
    pages.each do |page|
      begin
        new_page = page.random_link
        p new_page.url

        pp = new_page.longest_paragraph
        next if pp == nil
        pp.gsub!(/[^\w\n]{4}/, '~~~~')
        pp.gsub!('  ', '~~')
        f.write(pp)
        f.write("\n\n")
      rescue NetworkError => ex
        puts ex
      end
    end
  end
end


# require 'rubygems'
# require 'UniversalDetector'
# p UniversalDetector::chardet('Ascii text')
# p UniversalDetector::chardet('åäö')
