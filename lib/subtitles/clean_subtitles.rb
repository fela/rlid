#!/usr/bin/env ruby1.9.1

#
# converts files to UTF-8 and allows the user to discart wrong subtitles
#

require 'fileutils'

require 'common'

# encodings that can be used when not unicode
ENCODINGS = {
  :eng => ['ISO-8859-15'],
  :spa => ['ISO-8859-15'],
  :ger => ['ISO-8859-15'],
  :fre => ['ISO-8859-15'],
  :ita => ['ISO-8859-15'],
  :por => ['ISO-8859-15'],
  :dut => ['ISO-8859-15'],
  :pol => ['Windows-1250', 'ISO-8859-2'],
  :ind => ['ISO-8859-15'],
  :swe => ['ISO-8859-15'],
  :tur => ['ISO-8859-9'],
  :vie => [],
  :cze => ['Windows-1250', 'ISO-8859-2'],
  :rum => ['Windows-1250', 'ISO-8859-2'],
  :dan => ['ISO-8859-15'],
  :fin => ['ISO-8859-15'],
  :hun => ['Windows-1250', 'ISO-8859-2'],
  :ell => ['ISO-8859-7'],
  :cat => ['ISO-8859-15'],
  :nor => ['ISO-8859-15'],
  :slo => ['Windows-1250', 'ISO-8859-2'],
  :ice => ['ISO-8859-15'],
}

# always possible encodings
ENCODINGS_ALL = ['ISO-8859-15', 'ISO-8859-2', 'Windows-1252', 'Windows-1250']


class String
  def strange_chars
    strange = /[-\s\w,;'":?!()\[\]\.\/]/
    gsub(strange, '')
  end
end

class SubFile
  def initialize(language, filename)
    @language = language
    @filename = filename
    @path = "#{language}/#{filename}" # the old path!
    @string = File.read(@path)
  end

  # will save the file in unicode under the directory utf8
  def save_in_unicode
    enc = choose_encoding
    try_encoding(enc)
    print "save? [(Y)es/(n)o/(s)kip] "
    case gets.chomp
    when /^y/i, ''
      save enc
      puts "+++++++++++++ saved ++++++++++++++++"
    when /^s/i
      puts "!!---------- skipped --------------!!"
    else
      # retry
      save_in_unicode
    end
  end


private
  def save encoding
    @string.force_encoding(encoding)
    path = "#{@language}/utf8"
    FileUtils.makedirs(path)
    Dir.chdir(path) do
      File.open(@filename, 'w') do |file|
        file.write @string.encode('UTF-8')
      end
    end
  end

  def choose_encoding
    encs = possible_encodings

    puts ">> Choose an encoding:"
    encs.size.times {|i| print "#{i}: #{encs[i]},  "}
    print "> " # prompt
    # default is 0, woks outomatically
    index = gets.to_i

    if index > encs.size
      puts "invalid index!!"
      return choose_encoding
    end

    encs[index]
  end

  def try_encoding encoding
    @string.force_encoding(encoding)

    if not @string.valid_encoding?
      puts "Invalid encoding!!"
      return encoding
    end

    str = @string.dup
    str.encode!('UTF-8')

    puts '-----------------------------------'
    puts "(enc: #{encoding}, size: #{str.size/1000.0}k)"
    puts str.strange_chars[0..500]

    # print lines containing the chars to see them in the right context
    lines = str.split("\n")
    lines.delete_if {|a| a.strange_chars.size == 0}
    if not lines.size < 15
      puts lines[0..10].join("\n")
    else
      # no such lines
      puts str[0..250]
      puts " [...]"
      puts str[-200..-1]
    end
    encoding
  end

  def possible_encodings
    if defined? @possible_encodings
      return @possible_encodings
    end

    # else calculate it

    # duplicates will be removed
    res = ['UTF-8'] + ENCODINGS[@language] + ENCODINGS_ALL

    res.uniq!

    res.delete_if do |enc|
      @string.force_encoding(enc)
      not @string.valid_encoding?
    end

    @possible_encodings = res
  end
end

# LANGUAGES =

Dir.chdir(DATA_DIRECTORY)


#LANGUAGES.each do |lang|
[:rum].each do |lang|
Dir.open(lang.to_s) do |dir|
  puts "*********************************************"
  puts "******************* #{lang} *********************"
  puts "*********************************************"
  
  n_files = dir.entries.size - 2
  counter = 0
  dir.each do |filename|
    next if filename !~ /^\d+$/
    counter += 1

    begin
      puts '----------------------------------'
      puts "#{lang}/#{filename} (#{counter}/#{n_files})"

      file = SubFile.new(lang, filename)
      file.save_in_unicode
    rescue => ex
      warn ex
      warn ex.backtrace.join("\n")
      warn "unable to save #{lang}/#{filename}"
    end
  end
end
end
