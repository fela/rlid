#!/usr/bin/env ruby1.9.1

require 'common'

class String
  def cleanup!
    # strip spaces at start and end of lines
    gsub!(/^\s*/, '')
    gsub!(/\s*$/, '')
    # strip quotes when a line is 'text', or "text"
    gsub!(/^(['"])(.*)\1$/, '\2')
    # remove songs and descriptions for the deaf, etc. and similar bad lines
    # identifying them by the starting or ending character
    gsub!(/^[*#~(\[].*$/, '')
    gsub!(/^.*[*#~)\]]$/, '')
    # realign split lines
    gsub!(/\s*\. ?\. ?\.\n\. ?\. ?\.\s*/, ' ') # '...' on both ends
    gsub!(/\n\. ?\. ?\.\s*/, ' ') # '...' only at the start of the new line
    gsub!(/\s*\. ?\. ?\.\n/, ' ') # '...' at the end of a line
    gsub!(/\s*([^\.?!\n])\n/, '\1 ')
    # sometimes there is a space before ? or !, remove it
    gsub!(/ ([\?\!])/, '\1')
    # convert '--'
    gsub!("-- ", '... ')
    # remove all lines containing no lowerspace characters
    gsub!(/\n[^[:alpha:]]*\n/, "\n")
    # add newline ath the end
    self << "\n" if self[-1] != "\n"
    self
  end
end

Dir.chdir(DATA_DIRECTORY)

corpora = Hash.new("")

LANGUAGES.each do |lang|
Dir.open(lang.to_s + "/utf8") do |dir|
File.open(lang.to_s + '/corpus_long', "w") do |corpus|
  puts "creating corpus for #{lang}"
  dir.each do |file|
    next if file !~ /^\d+$/ # names should be all numbers
    newtext = File.read(dir.path + "/" + file).cleanup!

    # workaround for italian and french
    newtext.gsub!(/(\W)II(\W)/, '\1Il\2') if lang == :ita || lang == :fre

    # detect crappy OCR
    if newtext !~ /[[:lower:]]I/
      corpus.write(newtext)
      corpora[lang] = corpora[lang] + newtext
    else
      warn "skipped #{lang}/utf8/#{file}"
    end
#    newtext.each_line do |line|
#      if line =~ /[[:lower:]]I/ #or line =~ /[^\s]I[[:lower:]]/
#        puts line
#        puts "#{lang}/#{file}"
#      end
#    end
  end
end
end
end

shortest_text = corpora.values[0].size
corpora.values.each do |str|
  shortest_text = str.size if str.size < shortest_text
end

corpora_size = shortest_text * 9 / 10
test_size = shortest_text - corpora_size

puts "corpora has #{corpora_size} chars"
puts "test has #{test_size} chars"

Language.each_file("corpus", "w") do |file, lang|
  txt = corpora[lang][0...corpora_size]
  txt << "\n" if txt[-1] != "\n"
  file.write(txt)
end

Language.each_file("test_data", "w") do |file, lang|
  txt = corpora[lang][corpora_size...shortest_text]
  txt << "\n" if txt[-1] != "\n"
  file.write(txt)
end
