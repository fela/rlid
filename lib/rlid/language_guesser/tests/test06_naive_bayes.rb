require 'rlid/language_guesser/tests/test'
require 'rlid/language_guesser/model_distance_guesser'
require 'rlid/language_guesser/naive_bayes_guesser'
require 'rlid/models/ordered_ngrams'

require 'rlid/common'

guesser1 = ModelDistanceGuesser.new(NGrams3000)
guesser2 = NaiveBayesGuesser.new
guesser1.name = "ROC 3000"
guesser2.name = "naive bayes 3000"
t = Test.new
t.languages = COMMON_LANGUAGES
t.test_length = 25000
t.filename = "test_data"
t.guessers = [guesser2, guesser1]

result = t.execute
result.plot("naive_bayes")

#######################################################
#t.test_length = -1 # no limit
#t.languages = [:eng, :por]
#t.filename = "news_test"
#result = t.execute
#result.title = "News"
#result.plot("naive_bayes_news")
