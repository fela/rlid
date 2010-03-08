require 'language_guesser/tests/results'
require 'probabilities/language_probabilities'
require 'common'

# tests are performed on filename for every language
# the test is performed for each guesser class given and re results are compared
class Test
  attr_accessor :test_length, :filename, :languages, :guessers
  MAX_WORDS = 15
  MIN_CHARS = 1
  MAX_CHARS = 60
  DEFAULT_TEST_LENGHT = -1 # full length


  def initialize
    @test_length = DEFAULT_TEST_LENGHT
    @languages = LANGUAGES
  end

  def execute
    results = Results.new
    @guessers.each do |g|
      puts ">>> testing #{g.name} <<<"
      results << test(g)
    end
    results
  end


private
  def test(guesser)
    @current_guesser = guesser
    # indexes are character sizes
    @total_tests = Hash.new(0)
    @passed_tests = Hash.new(0)

    each_file do |file, lang|
      puts "- testing #{lang}"
      test_aux(file, lang)
    end

    res = Hash.new(0)
    @total_tests.each do |n, total|
      res[n] = @passed_tests[n].to_f / total if n>=MIN_CHARS && n<=MAX_CHARS
    end
    Results.new(guesser.name, res)
  end

  def test_aux(file, lang)
    if @current_guesser.respond_to?(:set_prior)
      @probabilities = TestProbabilities.new(lang)
    end

    all_words = file.read[0..test_length].split(' ')

    1.upto(MAX_WORDS) do |n_of_words|
    all_words.each_slice(n_of_words) do |a|
      str = a.join(' ')
      test_res = try_guess(str)
      @total_tests[str.size] += 1
      if test_res == lang
        @passed_tests[str.size] += 1
      elsif str.size > 70
        #warn str
      end
    end
    end
  end

  def try_guess(str)
    if @current_guesser.respond_to?(:set_prior)
      prior = @probabilities#.random_permutation
      @current_guesser.set_prior(prior)
    end
    @current_guesser.guess_language(str)
  end

  # each file @filename in the chosen languages
  def each_file
    languages.each do |lang_code|
      filepath = "#{DATA_DIRECTORY}/#{lang_code}/#{filename}"
      File.open(filepath, "r") do |file|
        yield file, lang_code
      end
    end
  end
end
