require 'rlid/language_guesser/naive_bayes_guesser'

module Rlid
  @guesser = SmartBayesGuesser.new
  def self.guess_language(string)
    @guesser.guess_language(string)
  end
end
