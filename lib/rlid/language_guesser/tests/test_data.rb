require 'rlid/common'
require 'rlid/language_guesser/tests/results'
require 'rlid/probabilities/language_probabilities'
require 'gnuplot'

module Rlid

class TestData
  
  def initialize filename
    # filename doesn't have to be a string because to_s is called on it
    @data = Marshal.load File.read(DIR + filename.to_s)
    @stats = {"reference" => {x: [0,1], y: [0,1]}}
  end

  # generates the data and stores it to the db
  def self.gen_data guesser, filename=nil
    start = Time.now
    filename ||= guesser.to_s
    data = {}

    g = guesser.new
    each_string do |str, lang|
      guess = g.guess_language(str)
      data[str] = {:language => lang, :guess => guess}
    end

    File.open(DIR + filename, "w") do |f|
      f.write Marshal.dump(data)
    end
    mins = ((Time.now - start) / 60).round
    hours = mins / 60
    mins %= 60
    puts "Data generation finished after #{hours} hours and #{mins} minutes"
  end

  def strings(minsize=nil, maxsize=nil)
    maxsize ||= minsize

    strings = @data.keys
    if minsize
      strings = strings.select {|s| (minsize..maxsize).include? s.size}
    end
    strings.map{|s| GuessedString.new(s, @data[s])}
  end

  # generates an histogram of the correctly guessed string vs the prob estimate
  def stats_for string_size_range, n_bins, min=0.05, max=0.95
    print "Selecting strings.. "
    strings = @data.keys.select {|s| string_size_range.include? s.size}
    puts "selected #{strings.size} of #{@data.size} strings!"

    bins = [[]] * n_bins
    bins.map!{|x| x.dup}
    # bins[i][n][:correct/:prob]
    binsize = (max-min)/n_bins

    strings.each do |s|
      reallang = @data[s][:language]
      guess = @data[s][:guess]
      guessed_lang = guess.first
      prob_estimate = guess[guessed_lang]
      correct = (guessed_lang == reallang)

      next if prob_estimate < min || prob_estimate >= max
      bin = ((prob_estimate-min) / binsize).floor
      bins[bin] << {prob: prob_estimate, correct: correct}
    end

    # res[i][:percentage/:reference]
    # percentage is the percentage of correctly guessed strings
    # reference is the percentage that should have been correctly guessed
    res = {y: [], x: []}
    bins.each_with_index do |bin|
      # correctly guessed / all strings in bin
      perc = bin.select{|b| b[:correct]}.size / bin.size.to_f
      ref = bin.inject(0) {|s, b| s + b[:prob]} / bin.size.to_f
      perc = 0 if perc.nan?
      ref = 0 if ref.nan?
      res[:y] << perc
      res[:x] << ref
    end
    @stats[string_size_range.to_s] = res
  end


  def plot(filename)
    # filename with complete path
    file = "#{DATA_DIRECTORY}/test_results/#{filename}.eps"
    Gnuplot.open do |gp|
    Gnuplot::Plot.new( gp ) do |plot|
      #plot.xrange "[#{xrange.first}:#{xrange.last}]"
      #plot.yrange "[#{yrange.first}:#{yrange.last}]"
      #plot.title title if title
      plot.xlabel "estimated accuracy"
      plot.ylabel "real accuracy"
      plot.output file
      plot.term "postscript eps enhanced"
      #plot.key "right bottom" # position of the labels

      plot.data = plot_data
    end
    end

    puts "== file saved to #{file} =="
  end



  def plot_data
    data = []
    @stats.each do |name, d|
      # covert to array and sort
      #combine_size = 1 # combine consecutive data...
      #a = hash.to_a.sort{|x, y| x[0] <=> y[0]}
      #a.delete_if{|x| not xrange.include? x[0]}
      #fill a
      #a.reverse!
      #x = a.map{|v| v[0]}.combine(combine_size)
      #y = a.map{|v| 1.0-v[1]}.combine(combine_size)
      x = d[:x]
      y = d[:y]
      data << Gnuplot::DataSet.new([x, y]) do |ds|
        ds.with = "lines"
        #ds.linewidth = 4
        ds.title = name if not name.empty?
      end
    end
    data
  end

private
  DIR = DATA_DIRECTORY + "/test_data/"
  FILENAME = "test_data"
  MAX_WORDS = 6

  #def self.each_string languages=[:eng, :dut]
  def self.each_string languages=LANGUAGES
    progress = 0.0
    languages.each do |lang_code|
      filepath = "#{DATA_DIRECTORY}/#{lang_code}/#{FILENAME}"
      File.open(filepath, "r") do |file|
        #all_words = file.read[0..test_length].split(' ')
        all_words = file.read.split(' ')

        1.upto(MAX_WORDS) do |n_of_words|
          progress += 1
          Rlid.scrollbar( progress / (languages.size * MAX_WORDS) )
          all_words.each_slice(n_of_words) {|a| yield a.join(" "), lang_code}
        end

      end
    end
  end

  # each file in the chosen languages
  def each_file languages
    languages.each do |lang_code|
      filepath = "#{DATA_DIRECTORY}/#{lang_code}/#{FILENAME}"
      File.open(filepath, "r") do |file|
        yield file, lang_code
      end
    end
  end
end

class GuessedString
  def initialize(string, data)
    @string, @lang, @guess = string, data[:language], data[:guess]
  end
end

end # module Rlid
