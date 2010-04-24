#!/usr/bin/env ruby1.9.1

require 'set'

require 'rlid/common'

class NaiveBayesModels
  attr_accessor :default_count
  # ngram leght
  N = 3
  # top ngrams kept for every language
  CUTOFF = 3000
  # special feature
  OTHER = nil

  MAX_STRING_LENGTH = 75

  FILEPATH = "#{DATA_DIRECTORY}/naive_bayes_models"

  def initialize(default_count=1)
    @default_count=default_count
  end

  def self.generate_models
    models = NaiveBayesModels.new(nil)
    puts "Training started.."
    models.train
    File.open(FILEPATH, "w") do |file|
      file.write Marshal.dump(models)
      puts "Models saved to #{FILEPATH}"
    end
  end

  def self.load
    Marshal.load(File.read(FILEPATH))
  end

  def probabilities(string)
    if not string.is_a? String
      raise InvalidArgument
    end
    @ngram_frequency.keys.each do |lang|
      prob = 1
      string[0..MAX_STRING_LENGTH].each_ngram do |ngram|
        prob *= frequency_of(lang, ngram)
      end
      yield lang, prob
    end
  end

  def train
    ngram_counts = get_ngram_counts
    # ngrams for which we want to store information (all languages)
    @stored_ngrams = top_ngrams(ngram_counts)

    puts "- processing ngrams"
    # content: ngram_frequency[lang][ngram] = freq
    @ngram_frequency = Hash.new
    # content: total_ngrams_found[lang] = total count of ngrams encountered
    @total_ngrams_found= Hash.new
    # content: total_ngrams_not_found[lang] = n of ngrams not found
    @total_ngrams_not_found = Hash.new

    ngram_counts.each do |lang, counts|
      @ngram_frequency[lang] = Hash.new(0)
      @total_ngrams_found[lang] = 0
      counts.each do |ngram, count|
        if @stored_ngrams.include?(ngram)
          @ngram_frequency[lang][ngram] = count
        else
          @ngram_frequency[lang][OTHER] += count
        end
        @total_ngrams_found[lang] += count
      end
      
      not_found = (@stored_ngrams - @ngram_frequency[lang].keys).size
      @total_ngrams_not_found[lang] = not_found

      puts_info(lang)
    end

    n = @ngram_frequency.values.map{|x| x[OTHER]}.max * 3 / 2 # (* 1.5)
    @total_ngrams_found[:nnn] = n
    @ngram_frequency[Language::NO_LANGUAGE_CODE] = {OTHER => n}
    @total_ngrams_not_found[:nnn] = @stored_ngrams.size
    
    #puts "total frequencies saved: #{freqs}"
    #puts "defauld values used: #{default_count} (#{100*default_count/freqs}%)"
    #@ngram_frequency
  end

protected
  def total_ngrams(lang)
    @total_ngrams_found[lang] + @total_ngrams_not_found[lang] * @default_count
  end

  def frequency_of(lang, ngram)
    if not @stored_ngrams.include?(ngram)
      #warn "  :#{ngram}: is in OTHER!" if lang == :eng
      ngram = OTHER
    end
    count = 0
    if @ngram_frequency[lang].include?(ngram)
      count = @ngram_frequency[lang][ngram]
    else
      count = @default_count
    end
    count.to_f / total_ngrams(lang)
  end

private

  def puts_info(lang)
    # default count of 1 is supposed
    tot = @total_ngrams_found[lang] + @total_ngrams_not_found[lang]
    d = (100.0 * @total_ngrams_not_found[lang] / tot).round(1)
    o = (100.0 * @ngram_frequency[lang][OTHER] / tot).round(1)
    puts "  #{lang} processed tot:#{tot}, default:#{d}%, other:#{o}%"
  end

  # auxiliary functions

  # gets all ngram_counts and returns an hash having:
  # ngram_counts[lang][ngram] = count
  def get_ngram_counts
    @stored_ngrams = Set.new
    ngram_counts = Hash.new
    Language.each_file("corpus") do |file, lang|
      puts "- I'm learning #{lang}"
      ngram_counts[lang] = Hash.new(0) # default is 1
      file.read.each_ngram(N) do |ngram|
        ngram_counts[lang][ngram] += 1
      end

      # top ngrams (transformed into arrays)
      arrays = ngram_counts[lang].to_a.sort{|x, y| y[1] <=> x[1]}
      @stored_ngrams += arrays[0...CUTOFF].map{|x| x[0]}
    end
    ngram_counts
  end

  # extract the top ngrams for every language
  def top_ngrams(ngram_counts)
    res = Set.new
    ngram_counts.values.each do |hash|
      # top ngrams (transformed into arrays)
      arrays = hash.to_a.sort{|x, y| y[1] <=> x[1]}
      res += arrays[0...CUTOFF].map{|x| x[0]}
    end
    res
  end
end
