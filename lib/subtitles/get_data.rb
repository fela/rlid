#!/usr/bin/env ruby1.9.1

# script to download subtitles
# change the languages used and query used

require 'subtitles/get_data_utils'

SubtitleServer.new do |server|
  # languages we want to download subtitles from
  LANGS = SubtitleServer.languages_with_few_subs
  # query (suggestions: the, and, 1999, 2000, 2001.. etc)
  QUERY = '2009'
  p LANGS
  [:rum].each do |lang|
    puts "== getting subs in #{lang} =="
    server.download_subs(lang, QUERY)
  end
end