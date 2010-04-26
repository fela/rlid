require 'rlid/language_guesser/naive_bayes_guesser'

class Rlid
  @guesser = NaiveBayesProbabilityGuesser.new
  def self.guess_language(string)
    @guesser.guess_language(string)
  end
end
