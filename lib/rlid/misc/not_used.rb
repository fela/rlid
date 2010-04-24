# miscellaneous functions I didn't use at the end

class SubtitleServer
  # finds the movies in all languages
  # I didn't manage to find anything
  def find_movies_in_all_language(query='the')
    q = {'query' => query}
    movies = search(q)['data']

    #movies.delete_if {|m| m["MovieName"] =~ /2008/}

    ids_and_titles = Hash.new
    movies.each do |movie|
      if not ids_and_titles[movie['IDMovieImdb']] # keep the first match
        ids_and_titles[movie['IDMovieImdb']] = movie['MovieName']
      end
    end

    ids_and_titles = ids_and_titles.to_a

    # movies_ok = [] # movies having subtitles in all languages
    ids_and_titles[3..10].each do |movieid, title|

      puts "trying #{title}"
      if in_all_languages? movieid
        puts "yes!"
      else
        puts "no :("
      end
    end
  end

  # finds movies that are in as much languages as possible
  # and shows some statistics
  def language_stats(query='the')
    movies = Hash.new
    movie_count = Hash.new [] # key is imdbid

    langs = LANGUAGES.reverse
    langs.each do |language|
      q = {'sublanguageid' => language.to_s, 'query' => query}
      movies_data = search(q)['data']
      if not movies_data
        warn  "error finding movies in #{language}"
        next
      end


      movies_data.each do |m|
        if not movies[m['IDMovieImdb']] # keep the first match
          movies[m['IDMovieImdb']] = m['MovieName']
        end
      end

      ids = Set.new(movies_data.map {|m| m['IDMovieImdb']}.uniq!)
      ids.each do |id|
        movie_count[id] = movie_count[id] + [language]
      end

      puts "checked #{language} (#{ids.size})"
    end

    count = movie_count.to_a
    count.sort! { |a, b| b[1].size <=> a[1].size }
    count[0..20].each do |id, langs|
      puts "#{langs.size} => #{id}: #{movies[id]}"
      puts (LANGUAGES - langs).join(" ")
    end

    #movies.values.each {|name| puts name}
  end

private
  def in_all_languages?(movieid)
    LANGUAGES.each do |lang|
      begin
        q = {'sublanguageid' => lang.to_s, 'imdbid' => movieid}

        res = search(q)
        if res['data'] == false
          puts "search for #{lang} returned false"
          return false
        end

        movies = res['data']
        if movies.empty?
          puts "no movies in #{lang}"
          return false
        end

        movies.delete_if {|m| m['SubFormat'] != 'srt'}
        if movies.empty?
          puts "no movies in #{lang} using .srt"
          return false
        end
      rescue => ex
        puts lang.to_s + " " + ex
        return false
      end
    end

    true
  end
end
