require 'language_guesser/tests/test'
require 'language_guesser/model_distance_guesser'
require 'language_guesser/naive_bayes_guesser'
require 'models/ordered_ngrams'

require 'common'

guesser1 = ModelDistanceGuesser.new(NGrams3000)
guesser2 = NaiveBayesGuesser.new
guesser1.name = "rank order"
guesser2.name = "naive bayes"
t = Test.new
t.languages = COMMON_LANGUAGES
t.test_length = 5000
t.filename = "test_data"
t.guessers = [guesser1, guesser2]

result = t.execute
result.plot("naive_bayes1")

#######################################################
#t.test_length = -1 # no limit
#t.languages = [:eng, :por]
#t.filename = "news_test"
#result = t.execute
#result.title = "News"
#result.plot("naive_bayes_news")
