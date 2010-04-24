load "rlid/subtitles/subtitle_server.rb"


class Array
  def for_none
     select{|el| yield el}.empty?
  end

  def for_all
    reject{|el| yield el}.empty?
  end
end

class SubtitleServer

  N_OF_SUBS = 40
  
  def download_subs(lang, query)
    @query = query
    dir = DATA_DIRECTORY + '/' + lang.to_s
    FileUtils.makedirs(dir)
    Dir.chdir(dir) do
      subs = find_subs(lang)
      subs.each do |sub|
        id = sub['IDSubtitleFile']
      

        begin
          txt = sub_text(id)
          if txt.size < 500
            raise "sub too short"
          end
        rescue => ex
          warn "invalid sub #{id} (#{sub['MovieName']}) #{ex}"
          next
        end
        # strip xml like tags
        txt.gsub!(/<[^>\n]+>/, '')
        # strip '-' at the beginning of the line
        txt.gsub!(/^-/, '')
        # strip trailing spaces
        txt.gsub!(/^\s+/, '')
        txt.gsub!(/\s+$/, '')
        # delete lines containing no lowercase characters
        txt.gsub!(/^[^[:lower:]]*$/, '')
        puts "saving #{id} (#{sub['MovieName']})"
        file_name = sub['IDMovieImdb']
        File.open(file_name, "w") do |f|
          f.write(txt)
        end
      end
    end
  end

  # returns the sub ids
  def find_subs(lang)
    q = {'sublanguageid' => lang.to_s, 'query' => @query}
    subs = search(q)['data']
    subs.delete_if{|s| s['SubFormat'] != 'srt'}

    if @query =~ /^\d\d\d\d$/ # a year
      subs.delete_if{|s| s['MovieName'].include?(@query)}
    end

    res = []

    while res.size < N_OF_SUBS
      # remov duplicates (and similar movies)
      newsubs = subs.select do |sub|
        res.for_none do |s|
          n1 =   s['MovieName'].gsub(/\W/, '')[0..8]
          n2 = sub['MovieName'].gsub(/\W/, '')[0..8]
          n1 == n2
        end
      end
      if newsubs.empty?
        warn "not enough subs for #{lang} (#{res.size})"
        break
      end
      res << newsubs.first
    end
    res
  end

  def SubtitleServer.languages_with_few_subs
    min_subs = 30
    LANGUAGES.select do |lang|
      path = DATA_DIRECTORY + '/' + lang.to_s
      # names should be composed by all digits
      subs = Dir.entries(path).select {|f| f =~ /^\d+$/}
      subs.size < min_subs
    end
  end
end

