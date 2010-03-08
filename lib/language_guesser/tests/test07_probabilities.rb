require 'language_guesser/tests/test'
require 'language_guesser/model_distance_guesser'
require 'language_guesser/naive_bayes_guesser'
require 'models/ordered_ngrams'

require 'common'

guesser1 = NaiveBayesPriorGuesser.new
guesser2 = NaiveBayesGuesser.new
guesser1.name = "with priors"
guesser2.name = "without priors"
t = Test.new
t.languages = COMMON_LANGUAGES
t.test_length = 25000
t.filename = "test_data"
t.guessers = [guesser1, guesser2]

result = t.execute
result.xrange = (0..35)
result.plot("probabilities")

